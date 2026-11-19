import { expect, test } from "bun:test";
import { parseCli } from "./args";

test("parses known flags, including --profile=<name>", () => {
  expect(parseCli(["--profile", "dev", "--dry-run", "--yes"])).toMatchObject({ profile: "dev", dryRun: true, yes: true });
  expect(parseCli(["--profile=minimal"]).profile).toBe("minimal");
  expect(parseCli(["-h"]).help).toBe(true);
  expect(parseCli([])).toMatchObject({ dryRun: false, yes: false, help: false });
});

test("a mistyped flag is rejected so it can never fall through to a real install", () => {
  expect(() => parseCli(["--profile", "dev", "--yes", "--dryrun"])).toThrow();
  expect(() => parseCli(["dev"])).toThrow();
});

test("--profile without a value is rejected instead of opening the menu", () => {
  expect(() => parseCli(["--profile"])).toThrow();
});
