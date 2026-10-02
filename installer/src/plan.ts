import type { Catalog, Module, OS, PlannedCommand, Step } from "./types";

const ID_RE = /^[A-Za-z0-9][A-Za-z0-9._\/-]*$/;

export function stepToArgv(step: Step): string[] {
  // Refs come from the catalog, but still reject anything shell-ish.
  if (!ID_RE.test(step.ref)) throw new Error(`invalid ref: ${step.ref}`);
  switch (step.kind) {
    case "apt": return ["sudo", "apt-get", "install", "-y", step.ref];
    case "brew": return ["brew", "install", step.ref];
    case "cask": return ["brew", "install", "--cask", step.ref];
    case "winget":
      return ["winget", "install", "--id", step.ref, "-e", "--accept-package-agreements", "--accept-source-agreements"];
    case "script": return ["bash", step.ref];
  }
}

export function resolveModules(catalog: Catalog, ids: string[]): Module[] {
  const byId = new Map(catalog.modules.map((m) => [m.id, m]));
  return [...new Set(ids)].map((id) => {
    const m = byId.get(id);
    if (!m) throw new Error(`unknown module: ${id}`);
    return m;
  });
}

export function buildPlan(mods: Module[], os: OS): { commands: PlannedCommand[]; skipped: Module[] } {
  const commands: PlannedCommand[] = [];
  const skipped: Module[] = [];
  for (const m of mods) {
    const step = m.install[os];
    if (!step) skipped.push(m);
    else commands.push({ moduleId: m.id, argv: stepToArgv(step), label: `${step.kind} ${step.ref}` });
  }
  return { commands, skipped };
}
