import ora from 'ora';
import path from 'path';
import fs from 'fs-extra';
import yaml from 'js-yaml';
import { PybytesAwsUtils } from '@pycom/pybytes-aws-utils';
import { IDeployInput, IShellResult } from '../interfaces';
import {
    AWSHelpers,
    Questions,
    getInputValue,
    assertValidEnvironment,
    assertValidApplicationName,
    runShellCommand,
    sleep,
    shortTime,
} from '../utils';

export async function deployEBSEnvironment(params: IDeployInput): Promise<void> {
    const spinner = ora({ text: 'initializing' }).start();
    const client = new AWSHelpers(params.awsCredentials, params.awsRegion);
    const qHelper = new Questions();
    spinner.stop();

    const awsEnvironment = await getInputValue(qHelper, 'aws environment name:', params.awsEnvironment);
    if (!awsEnvironment) {
        spinner.fail('AWS Environment is required');
        return process.exit(1);
    }
    spinner.start('assertValidEnvironment');
    if (!(await assertValidEnvironment(client, awsEnvironment))) {
        spinner.fail('Invalid AWS environment');
        return process.exit();
    }
    client.setEnvironment(awsEnvironment);
    spinner.stop();

    const exCommands = params.extraCommands ? JSON.parse(params.extraCommands) : undefined;

    spinner.start('get AWS applications');
    const listAllApps = await client.getApplications();
    spinner.stop();

    let application = params.awsApplication;
    if (!application) {
        application = await qHelper.askAboutAwsApplication([...listAllApps]);
    }
    if (!assertValidApplicationName(listAllApps, application)) {
        spinner.fail('Invalid Application Name');
        return process.exit();
    }
    client.setApplication(application);

    const appName = await getInputValue(qHelper, 'Application Name (github repository name):', params.appName);
    const tenant = await getInputValue(qHelper, 'tenant name example: pycom, murata, ...', params.tenant);
    const s3Region = await getInputValue(qHelper, 'aws s3 region name (read config files)', params.s3Region);
    const configProvider = await getInputValue(qHelper, 'config provider example: AWS, ...', params.configProvider);
    const appEnv = await getInputValue(qHelper, 'which environment app will use (staging, production, ..)', params.env);

    let domainNames;
    if (!params.domainName) domainNames = await getInputValue(qHelper, 'list of domain names:', params.domainNames);
    let domainName;
    if (!domainNames) {
        domainName = await getInputValue(qHelper, 'domain name only one for old apps:', params.domainName);
    }

    spinner.start('prepare working directory');
    const workingDirectory = path.join('/tmp', awsEnvironment);
    fs.removeSync(workingDirectory);
    spinner.stop();

    let cloudRepo = params.cloudRepository;
    if (!params.cloudRepository && !params.path) {
        cloudRepo = await getInputValue(qHelper, 'Cloud repository url:');
    }

    if (!cloudRepo) {
        const appDirectory = params.path || (await qHelper.askAboutWorkingDirectory());
        if (!appDirectory) {
            spinner.fail(
                'A source code is required either by pointing to  local location or provide a cloud repository url',
            );
            return process.exit();
        }
        spinner.start('copy directory to workingDirectory');
        await fs.copy(`${appDirectory}`, `${workingDirectory}`, { dereference: true });
        spinner.stop();
    } else {
        spinner.start('cloning the cloud repository');
        const result = await runShellCommand(`git clone ${cloudRepo} ${workingDirectory}`);
        if (result['stderr']) {
            spinner.fail(`Invalid Repository Name: ${result['stderr']}`);
            return process.exit();
        }
        spinner.stop();
    }

    let { stdout: branch } = await runShellCommand('git rev-parse --abbrev-ref HEAD', workingDirectory);
    branch = branch ? branch.trim() : 'develop';

    if (params.remoteConfigs) {
        spinner.start('getting frontend configuration');
        const s3BucketName = `apps-config-${tenant}-${appEnv}`;
        const s3ConfigKey = `${appName}/config.json`;
        const appConfig: IShellResult = await PybytesAwsUtils.getConfiguration(s3BucketName, s3ConfigKey, s3Region);
        Object.keys(appConfig).map((k) => {
            fs.appendFileSync(`${workingDirectory}/.env.production`, `${k}="${appConfig[k]}"\n`);
        });
        spinner.stop();
    }
    if (params.npmInstall) {
        fs.removeSync(`${workingDirectory}/node_modules`);
        fs.removeSync(`${workingDirectory}/package-lock.json`);
        await runShellCommand('npm install --scripts-prepend-node-path', workingDirectory);
    }

    if (params.build) {
        await runShellCommand('npm run build --scripts-prepend-node-path', workingDirectory);
    }

    if (exCommands) {
        spinner.start('run extra commands');
        for (let i = 0; i < exCommands.length; i++) {
            await runShellCommand(exCommands[i], workingDirectory);
        }
        spinner.stop();
    }

    spinner.start('configuring ebInitConfig');
    const ebInitConfig = {
        'branch-defaults': {
            [branch || 'develop']: {
                environment: awsEnvironment,
            },
        },
        'environment-defaults': {
            [awsEnvironment]: {
                branch: null,
                repository: null,
            },
        },
        global: {
            application_name: application,
            default_ec2_keyname: 'aws-key-eb',
            default_region: params.awsRegion,
            include_git_submodules: true,
            instance_profile: null,
            platform_name: null,
            platform_version: null,
            profile: 'eb-cli',
            sc: 'git',
            workspace_type: 'Application',
        },
    };

    let yamlEbInitConfig = yaml.dump(ebInitConfig);
    yamlEbInitConfig = yamlEbInitConfig.replace(/'/g, '');
    fs.outputFileSync(`${workingDirectory}/.elasticbeanstalk/config.yml`, yamlEbInitConfig);

    let optionsConfigFile;
    try {
        optionsConfigFile = fs.readFileSync(`${workingDirectory}/.ebextensions/options.config`, 'utf8');
    } catch (e) {
        spinner.info('no options.config');
    }
    if (optionsConfigFile) {
        if (configProvider) {
            optionsConfigFile = optionsConfigFile.replace(/CONFIG_PROVIDER/g, `CONFIG_PROVIDER: ${configProvider}`);
        }
        if (s3Region) {
            optionsConfigFile = optionsConfigFile.replace(/S3_BUCKET_REGION/g, `S3_BUCKET_REGION: ${s3Region}`);
        }
        if (tenant) {
            optionsConfigFile = optionsConfigFile.replace(/TENANT/g, `TENANT: ${tenant}`);
        }
        if (appEnv) {
            optionsConfigFile = optionsConfigFile.replace(/APP_ENV/g, `APP_ENV: ${appEnv}`);
        }
        if (appName) {
            optionsConfigFile = optionsConfigFile.replace(/APP_NAME/g, `APP_NAME: ${appName}`);
        }
        fs.writeFileSync(`${workingDirectory}/.ebextensions/options.config`, optionsConfigFile);
    }

    if (domainName) {
        let nginxConfigFile = fs.readFileSync(`${workingDirectory}/.ebextensions/nginx.config`, 'utf8');
        nginxConfigFile = nginxConfigFile.replace(/DOMAIN_NAME_VALUE/g, domainName);
        fs.writeFileSync(`${workingDirectory}/.ebextensions/nginx.config`, nginxConfigFile, 'utf8');
    }

    let sslHelperFile;
    try {
        sslHelperFile = fs.readFileSync(`${workingDirectory}/.platform/hooks/postdeploy/01_ssl_helper.sh`, 'utf8');
    } catch (e) {
        spinner.info('no 01_ssl_helper.sh');
    }
    if (sslHelperFile) {
        if (domainNames) sslHelperFile = sslHelperFile.replace(/DOMAIN_NAMES/g, domainNames);
        if (domainName) sslHelperFile = sslHelperFile.replace(/DOMAIN_NAME_VALUE/g, domainName);
        fs.writeFileSync(`${workingDirectory}/.platform/hooks/postdeploy/01_ssl_helper.sh`, sslHelperFile, 'utf8');
    }

    if (params.androidAppId) {
        const androidFile = `${workingDirectory}/public/assets/assetlinks.json`;
        let androidDeepLinkFile = fs.readFileSync(androidFile, 'utf8');
        androidDeepLinkFile = androidDeepLinkFile.replace(/ANDROID_APP_ID/g, params.androidAppId);
        fs.writeFileSync(androidFile, androidDeepLinkFile, 'utf8');
    }

    if (params.iosAppId) {
        const iosFile = `${workingDirectory}/public/assets/apple-app-site-association`;
        let iosDeepLinkFile = fs.readFileSync(iosFile, 'utf8');
        iosDeepLinkFile = iosDeepLinkFile.replace(/APP_ID/g, params.iosAppId);
        fs.writeFileSync(iosFile, iosDeepLinkFile, 'utf8');
    }

    const packageJson = JSON.parse(fs.readFileSync(`${workingDirectory}/package.json`, 'utf8'));
    const version = packageJson.version;
    const name = packageJson.name;
    const cD = new Date().toISOString();
    const label = `${name}@v${version}-${branch}-${cD}`;
    spinner.stop();

    const finalConfirmation = params.skipConfirm || (await qHelper.askAboutFinalDeployConfirmation());

    if (finalConfirmation) {
        if (params.dry) {
            spinner.info('dry run Deployed Successfully 🚀🚀🚀');
            return process.exit();
        }
        spinner.info(`deploying ${label} ....`);
        fs.removeSync(`${workingDirectory}/node_modules`);
        runShellCommand(`eb deploy ${awsEnvironment} --label ${label} `, workingDirectory)
            .then((result) => {
                console.log(result);
            })
            .catch((e) => {
                console.log(e);
            });
        await sleep(1000);
        spinner.start('deploying...');
        await client.watchEnvironmentDeployment(awsEnvironment, (m) => {
            spinner.stop();
            if (typeof m === 'string') spinner.info(m);
            else {
                if (m.Severity === 'ERROR') spinner.fail(`${m.Severity} - ${shortTime(m.EventDate)} ${m.Message}`);
                else spinner.info(`${m.Severity} - ${shortTime(m.EventDate)} ${m.Message}`);
            }
            spinner.start('deploying...');
        });
        spinner.stop();
        spinner.succeed('Deployments finished 🚀🚀🚀 Check the logs!');
    } else {
        spinner.info('Not deployed!');
    }

    if (params.cleanTempDirectory) {
        spinner.start('cleaning temporary directory');
        fs.removeSync(workingDirectory);
        spinner.stop();
    }
}
