import { parseArgs } from "node:util";

export interface Cli { help: boolean; dryRun: boolean; yes: boolean; profile?: string }

// strict: a mistyped flag such as `--dryrun` must fail instead of silently running a real install.
export function parseCli(argv: string[]): Cli {
  const { values } = parseArgs({
    args: argv,
    allowPositionals: false,
    strict: true,
    options: {
      help: { type: "boolean", short: "h" },
      "dry-run": { type: "boolean" },
      yes: { type: "boolean" },
      profile: { type: "string" },
    },
  });
  return { help: !!values.help, dryRun: !!values["dry-run"], yes: !!values.yes, profile: values.profile };
}
