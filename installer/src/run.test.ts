import { expect, test } from "bun:test";
import { runCommand } from "./run";

test("dry run never spawns anything", async () => {
  const r = await runCommand({ moduleId: "x", argv: ["definitely-not-a-binary-xyz"], label: "x" }, true);
  expect(r).toEqual({ moduleId: "x", ok: true, code: 0 });
});

test("a missing executable is a failed step (127), not a crash", async () => {
  const r = await runCommand({ moduleId: "x", argv: ["definitely-not-a-binary-xyz"], label: "x" }, false);
  expect(r).toEqual({ moduleId: "x", ok: false, code: 127 });
});

test("a non-zero exit code is reported as failure with that code", async () => {
  const r = await runCommand({ moduleId: "x", argv: ["sh", "-c", "exit 3"], label: "x" }, false);
  expect(r).toEqual({ moduleId: "x", ok: false, code: 3 });
});
