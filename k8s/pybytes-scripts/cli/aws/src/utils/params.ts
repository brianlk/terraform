import { Questions } from './questions';

export async function getInputValue(qHelper: Questions, question: string, value?: string): Promise<string | undefined> {
    if (value) return value;
    const valueQuestion = await qHelper.askAboutStringInput(question);
    return valueQuestion;
}
