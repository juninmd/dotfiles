import catalog from "../catalog/catalog.json";
import { parseCli } from "./args";
import { detectOS } from "./platform";
import { start } from "./ui";
import type { Catalog } from "./types";

const usage = "Uso: dotfiles [--profile <nome>] [--dry-run] [--yes]\nPerfis: " + Object.keys((catalog as Catalog).profiles).join(", ");
let cli;
try {
  cli = parseCli(process.argv.slice(2));
} catch (err) {
  console.error(`${(err as Error).message}\n${usage}`);
  process.exit(2);
}
if (cli.help) {
  console.log(usage);
  process.exit(0);
}
await start(catalog as Catalog, detectOS(), { dryRun: cli.dryRun, yes: cli.yes, profile: cli.profile });
