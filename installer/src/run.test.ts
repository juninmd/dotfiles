import { expect, test } from "bun:test";
import { runCommand, tail } from "./run";

test("dry run never spawns anything", async () => {
  const r = await runCommand({ moduleId: "x", argv: ["definitely-not-a-binary-xyz"], label: "x" }, true);
  expect(r).toEqual({ moduleId: "x", ok: true, code: 0 });
});

test("a missing executable is a failed step (127), not a crash", async () => {
  const r = await runCommand({ moduleId: "x", argv: ["definitely-not-a-binary-xyz"], label: "x" }, false);
  expect(r).toEqual({ moduleId: "x", ok: false, code: 127, detail: "comando não encontrado: definitely-not-a-binary-xyz" });
});

test("a non-zero exit code is reported as failure with that code", async () => {
  const r = await runCommand({ moduleId: "x", argv: ["sh", "-c", "exit 3"], label: "x" }, false);
  expect(r).toEqual({ moduleId: "x", ok: false, code: 3 });
});

test("a failure carries the end of stderr so the user sees why", async () => {
  const r = await runCommand(
    { moduleId: "x", argv: ["sh", "-c", "echo noise >&2; echo 'E: Unable to locate package foo' >&2; exit 100"], label: "x" },
    false,
  );
  expect(r).toEqual({ moduleId: "x", ok: false, code: 100, detail: "noise\nE: Unable to locate package foo" });
});

test("tail keeps only the last lines", () => {
  expect(tail("1\n2\n3\n4\n5\n6\n7\n")).toBe("3\n4\n5\n6\n7");
});
