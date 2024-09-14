import {
    CreateEnvironmentCommandInput,
    DescribeApplicationsCommand,
    DescribeEnvironmentsCommand,
    DescribeEventsCommand,
    ElasticBeanstalkClient,
    ElasticBeanstalkClientConfig,
    EventDescription,
} from '@aws-sdk/client-elastic-beanstalk';
import { CallbackLogs } from '../interfaces';

export class AWSHelpers {
    awsClient: ElasticBeanstalkClient;
    environmentId: string | undefined;
    region: string;
    application: string | undefined;
    environment: string | undefined;
    environmentConfig: CreateEnvironmentCommandInput | undefined;

    constructor(credentials: boolean, region = 'eu-central-1') {
        this.region = region;
        const awsConfigs: ElasticBeanstalkClientConfig = { region };
        if (credentials) {
            const { aws_access_key_id: accessKeyId, aws_secret_access_key: secretAccessKey } = process.env;
            if (!accessKeyId || !secretAccessKey)
                throw new Error('aws_secret_access_key, aws_access_key_id are required');

            awsConfigs.credentials = {
                secretAccessKey,
                accessKeyId,
            };
        }
        this.awsClient = new ElasticBeanstalkClient(awsConfigs);
    }

    setEnvironment(environmentName: string): void {
        this.environment = environmentName;
    }

    setApplication(value: string): void {
        this.application = value;
    }

    async getApplications(): Promise<string[]> {
        const cmd = new DescribeApplicationsCommand({});
        try {
            const result = await this.awsClient.send(cmd);
            if (!result.Applications || result.Applications.length === 0) return [];
            return result.Applications.map((s) => s.ApplicationName || 'n/a');
        } catch (error) {
            const err = error as Error;
            console.log(err.message);
            throw new Error(err.message);
        }
    }

    async getEnvironment(environments: string[]): Promise<string[]> {
        const cmd = new DescribeEnvironmentsCommand({
            EnvironmentNames: environments,
        });
        try {
            const result = await this.awsClient.send(cmd);
            if (!result.Environments || result.Environments.length === 0) return [];
            return result.Environments.map((s) => s.EnvironmentName || 'n/a');
        } catch (error) {
            const err = error as Error;
            throw new Error(err.message);
        }
    }

    createGetNextEvents(): () => Promise<EventDescription[]> {
        let StartTime = new Date(Date.now());
        let lastBatch: EventDescription[] = [];
        const environmentId = this.environmentId;
        const getNextEvents = async () => {
            const command = new DescribeEventsCommand({ EnvironmentId: environmentId, StartTime });
            const data = await this.awsClient.send(command);

            if (data && data.Events && data.Events.length && data.Events[0]?.EventDate) {
                // set start time to most recent
                StartTime = new Date(data.Events[0].EventDate);

                // filter events that have already been returned
                const events = data.Events.filter(
                    (event) =>
                        !lastBatch.find((oldEvent) => {
                            if (oldEvent.EventDate && oldEvent.Message) {
                                return oldEvent.EventDate + oldEvent.Message === event.EventDate + oldEvent.Message;
                            }
                            return false;
                        }),
                );

                lastBatch = [...data.Events];
                return events;
            }

            return [];
        };

        return getNextEvents;
    }

    async watchEnvironmentDeployment(name: string, callbackLogs: CallbackLogs): Promise<void> {
        const describeCommand = new DescribeEnvironmentsCommand({
            EnvironmentNames: [name],
        });

        const getNextEvents = this.createGetNextEvents();

        callbackLogs(`deploying environment with Name: ${name}`);
        const checker = () => {
            return new Promise((resolve) => {
                let oldStatus = 'Ready';
                const interval = setInterval(async () => {
                    const data = await this.awsClient.send(describeCommand);
                    if (!data || !data.Environments) return;
                    const env = data.Environments[0];
                    const events = await getNextEvents();
                    [...events].reverse().forEach(callbackLogs);

                    if (env && env.Status === 'Ready' && env.Status !== oldStatus) {
                        clearInterval(interval);
                        callbackLogs(`finished deployment - status: ${env.Status}, health: ${env.HealthStatus}`);
                        resolve(true);
                    }
                    oldStatus = env && env.Status ? env.Status : 'Ready';
                }, 10000);
            });
        };
        await checker();
    }
}
