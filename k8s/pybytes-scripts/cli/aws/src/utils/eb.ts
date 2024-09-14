import { AWSHelpers } from './aws';

export async function assertValidEnvironment(client: AWSHelpers, awsEnvironment: string): Promise<boolean> {
    try {
        const awsEnvironmentApp = await client.getEnvironment([awsEnvironment]);
        return awsEnvironmentApp.includes(awsEnvironment);
    } catch (err) {
        return false;
    }
}

export function assertValidApplicationName(listAllApps: string[], appName: string): boolean {
    return listAllApps.includes(appName);
}
