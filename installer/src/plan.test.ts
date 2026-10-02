import { expect, test } from "bun:test";
import { existsSync } from "node:fs";
import { join } from "node:path";
import catalog from "../catalog/catalog.json";
import { buildPlan, resolveModules, stepToArgv } from "./plan";
import type { Catalog } from "./types";

const cat = catalog as Catalog;

test("every profile references only existing modules", () => {
  for (const p of Object.values(cat.profiles)) expect(() => resolveModules(cat, p.modules)).not.toThrow();
});

test("every module installs on at least Linux and every profile module on all three OSes", () => {
  for (const m of cat.modules) expect(m.install.linux).toBeDefined();
  const inProfiles = new Set(Object.values(cat.profiles).flatMap((p) => p.modules));
  for (const m of cat.modules.filter((m) => inProfiles.has(m.id))) expect(Object.keys(m.install).sort()).toEqual(["linux", "macos", "windows"]);
});

test("module ids are unique and every script ref exists in the repo", () => {
  expect(new Set(cat.modules.map((m) => m.id)).size).toBe(cat.modules.length);
  for (const m of cat.modules) for (const st of Object.values(m.install))
    if (st.kind === "script") expect(existsSync(join(import.meta.dir, "../..", st.ref))).toBe(true);
});

test("every step in the catalog builds a valid command", () => {
  for (const m of cat.modules) expect(() => buildPlan([m], "linux")).not.toThrow();
  for (const m of cat.modules) expect(() => buildPlan([m], "macos")).not.toThrow();
  for (const m of cat.modules) expect(() => buildPlan([m], "windows")).not.toThrow();
});

test("plan maps to the native package manager per OS", () => {
  const mods = resolveModules(cat, ["git"]);
  expect(buildPlan(mods, "linux").commands[0]!.argv.slice(0, 3)).toEqual(["sudo", "apt-get", "install"]);
  expect(buildPlan(mods, "macos").commands[0]!.argv[0]).toBe("brew");
  expect(buildPlan(mods, "windows").commands[0]!.argv[0]).toBe("winget");
});

test("modules without a step for the OS are skipped, not failed", () => {
  const m = { id: "x", name: "x", desc: "", category: "c", install: { linux: { kind: "apt", ref: "x" } } } as const;
  const r = buildPlan([m as never], "windows");
  expect(r.commands).toHaveLength(0);
  expect(r.skipped).toHaveLength(1);
});

test("shell metacharacters in a ref are rejected", () => {
  expect(() => stepToArgv({ kind: "apt", ref: "git; rm -rf /" })).toThrow();
  expect(() => stepToArgv({ kind: "apt", ref: "$(whoami)" })).toThrow();
});

test("unknown module id fails loudly", () => {
  expect(() => resolveModules(cat, ["nope"])).toThrow(/unknown module/);
});
