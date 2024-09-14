#!/usr/bin/env node

import dotenv from 'dotenv';
import { Command } from 'commander';
import { deployEBSEnvironment } from './bll';
import packageJson from '../package.json';

dotenv.config();

const program = new Command();

program.version(packageJson.version, '-v, --vers', 'output the current version');

program
    .command('deploy')
    .option('  , --aws-environment <aws environment>', 'aws environment name')
    .option('  , --aws-credentials', 'use an explicit credentials to access aws', false)
    .option('  , --aws-application <awsApplication>', 'target aws application')
    .option('  , --aws-region <awsRegion>', 'target region', 'eu-central-1')
    .option('  , --config-provider <configProvider>', 'configProvider')
    .option('  , --s3-region <s3Region>', 's3Region')
    .option('  , --domain-names <domainNames>', 'list of domain separated by ","')
    .option('  , --domain-name <domainName>', 'some apps use only one domain (old apps)')
    .option('  , --env <env>', 'environment name [staging, production, ...]')
    .option('  , --path <path>', 'path for the app')
    .option('  , --cloud-repository <cloudRepository>', 'The cloud repository url')
    .option('  , --app-name <path>', 'app name [pyconfig, pyauth, pylife-api, ...]')
    .option('  , --remote-configs', 'read configuration from s3 and convert to env variables', false)
    .option('  , --tenant <tenant>', 'tenant name [pycom, murata, ...]')
    .option('  , --extra-commands <extraCommands>', 'additional commands ["npm i", ..]')
    .option('  , --ios-app-id <iosAppId>', 'ios Application ID for pylife (deep-link)')
    .option('  , --android-app-id <androidAppId>', 'android Application ID for pylife (deep-link)')
    .option('  , --skip-confirm', 'skip confirmation', false)
    .option('  , --clean-temp-directory', 'Flag to clean temporary directory at the end', false)
    .option('-b, --build', 'build project', false)
    .option('-i, --npm-install', 'build project', false)
    .option('-d, --dry', 'dry run', false)
    .action(deployEBSEnvironment);

program.parse(process.argv);
