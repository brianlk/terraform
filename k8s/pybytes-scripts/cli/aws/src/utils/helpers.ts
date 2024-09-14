import { promisify } from 'util';
import { exec, ExecSyncOptions } from 'child_process';
import { IShellResult } from '../interfaces';

const execPromise = promisify(exec);

export function shortTime(d: Date | undefined): string {
    if (!d) return '';
    return [d.getHours(), d.getMinutes(), d.getSeconds()].join(':');
}

export function logError(message: string): void {
    const red = '\x1b[31m';
    const reset = '\x1b[0m';
    console.log(`${red} ${message} ${reset}`);
}

export function logInfo(message: string): void {
    const yellow = '\x1b[33m';
    const reset = '\x1b[0m';
    console.log(`${yellow} ${message} ${reset}`);
}

/**
 * It runs a shell command returning stdout and stderr, if any
 * @param  {string} command one or more commands that can be run in a shell
 * @return {object}         stdout and stderr
 */
export async function runShellCommand(
    command: string,
    cwd?: string | undefined,
    shell = '/bin/bash',
): Promise<IShellResult> {
    let stdout;
    try {
        const options: ExecSyncOptions = {
            encoding: 'utf8',
        };
        if (cwd) options.cwd = cwd;
        if (shell) options.shell = shell;

        ({ stdout } = await execPromise(command, options));
        logInfo(stdout);
        return { stdout };
    } catch (e) {
        console.error(e);
        return { stderr: (e as Error).message };
    }
}

export function sleep(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
}
