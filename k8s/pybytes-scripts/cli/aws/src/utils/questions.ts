import { prompt } from 'enquirer';
import { IAskAboutDbResponse, IQuestionDBDetails, IQuestionsChoice, IQuestionsConfirm } from '../interfaces';

export class Questions {
    async askAboutAwsApplication(applications: string[]): Promise<string> {
        const solutionStackChoice: IQuestionsChoice = await prompt({
            type: 'select',
            message: 'Please select an aws application?',
            choices: applications,
            name: 'value',
        });
        return solutionStackChoice.value;
    }

    async askAboutDB(): Promise<IAskAboutDbResponse> {
        const confirmDb: IQuestionsConfirm = await prompt({
            type: 'confirm',
            message: 'Add a Database?',
            name: 'value',
        });

        if (!confirmDb.value) return { db: confirmDb.value };

        const dbDetails: IQuestionDBDetails = await prompt([
            {
                type: 'input',
                name: 'username',
                message: 'Enter DB username: ',
            },
            {
                type: 'password',
                name: 'password',
                message: 'Enter DB password: ',
            },
        ]);

        return { db: confirmDb.value, username: dbDetails.username, password: dbDetails.password };
    }

    async askAboutFinalDeployConfirmation(): Promise<boolean> {
        const finalConfirmation: IQuestionsConfirm = await prompt({
            type: 'confirm',
            message: 'Ready to deploy?',
            name: 'value',
        });
        return finalConfirmation.value;
    }

    async askAboutWorkingDirectory(): Promise<string> {
        const filePath: IQuestionsChoice = await prompt({
            type: 'input',
            message: 'Absolute path for the root app folder',
            name: 'value',
        });
        return filePath.value;
    }

    async askAboutStringInput(message: string): Promise<string | undefined> {
        const filePath: IQuestionsChoice = await prompt({
            type: 'input',
            message,
            name: 'value',
        });
        return filePath.value;
    }
}
