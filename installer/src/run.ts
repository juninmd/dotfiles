import type { PlannedCommand } from "./types";

export interface RunResult { moduleId: string; ok: boolean; code: number; detail?: string }

/** Last lines of stderr: enough to say why apt/brew/winget failed without flooding the summary. */
const TAIL_LINES = 5;
export const tail = (text: string, n = TAIL_LINES) => text.trim().split(/\r?\n/).slice(-n).join("\n");

export async function runCommand(cmd: PlannedCommand, dryRun: boolean): Promise<RunResult> {
  if (dryRun) return { moduleId: cmd.moduleId, ok: true, code: 0 };
  // No shell: argv goes straight to the OS, so refs can never be interpreted as shell syntax.
  // A missing binary (no brew/winget/sudo) makes spawn throw; report it as a failed step so the
  // remaining modules still run and the final summary lists it instead of crashing mid-install.
  try {
    const proc = Bun.spawn(cmd.argv, { stdout: "ignore", stderr: "pipe" });
    const [stderr, code] = await Promise.all([new Response(proc.stderr).text(), proc.exited]);
    if (code === 0) return { moduleId: cmd.moduleId, ok: true, code };
    return { moduleId: cmd.moduleId, ok: false, code, detail: tail(stderr) || undefined };
  } catch {
    return { moduleId: cmd.moduleId, ok: false, code: 127, detail: `comando não encontrado: ${cmd.argv[0]}` };
  }
}
