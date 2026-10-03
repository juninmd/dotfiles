import type { PlannedCommand } from "./types";

export interface RunResult { moduleId: string; ok: boolean; code: number }

export async function runCommand(cmd: PlannedCommand, dryRun: boolean): Promise<RunResult> {
  if (dryRun) return { moduleId: cmd.moduleId, ok: true, code: 0 };
  // No shell: argv goes straight to the OS, so refs can never be interpreted as shell syntax.
  const proc = Bun.spawn(cmd.argv, { stdout: "ignore", stderr: "ignore" });
  const code = await proc.exited;
  return { moduleId: cmd.moduleId, ok: code === 0, code };
}
