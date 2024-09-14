import { EventDescription } from '@aws-sdk/client-elastic-beanstalk';

export interface IDeployInput {
    awsEnvironment: string;
    awsCredentials: boolean;
    awsApplication?: string;
    awsRegion: string;
    s3Region?: string;
    configProvider?: string;
    domainNames?: string;
    domainName?: string;
    androidAppId?: string;
    iosAppId?: string;
    env?: string;
    path?: string;
    cloudRepository?: string;
    appName: string;
    tenant: string;
    extraCommands?: string;
    build: boolean;
    npmInstall?: string;
    remoteConfigs: boolean;
    skipConfirm: boolean;
    dry: boolean;
    cleanTempDirectory: boolean;
}

export interface IQuestionsChoice {
    value: string;
}

export interface IQuestionsConfirm {
    value: boolean;
}

export interface IQuestionDBDetails {
    username: string;
    password: string;
}

export interface IAskAboutDbResponse {
    db: boolean;
    username?: string;
    password?: string;
}

export interface IShellResult {
    [key: string]: string;
}

export type CallbackLogs = (a: string | EventDescription) => void;
