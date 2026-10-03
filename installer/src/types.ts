export type OS = "linux" | "macos" | "windows";
export type StepKind = "apt" | "brew" | "cask" | "winget" | "script";
export interface Step { kind: StepKind; ref: string }
export interface Module {
  id: string; name: string; desc: string; category: string;
  install: Partial<Record<OS, Step>>;
}
export interface Profile { name: string; desc: string; modules: string[] }
export interface Catalog { profiles: Record<string, Profile>; modules: Module[] }
export interface PlannedCommand { moduleId: string; argv: string[]; label: string }
