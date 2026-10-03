import catalog from "../catalog/catalog.json";
import { detectOS } from "./platform";
import { start } from "./ui";
import type { Catalog } from "./types";

const args = process.argv.slice(2);
if (args.includes("--help") || args.includes("-h")) {
  console.log("Uso: dotfiles [--profile <nome>] [--dry-run] [--yes]\nPerfis: " + Object.keys((catalog as Catalog).profiles).join(", "));
  process.exit(0);
}
const pi = args.indexOf("--profile");
await start(catalog as Catalog, detectOS(), {
  dryRun: args.includes("--dry-run"),
  yes: args.includes("--yes"),
  profile: pi >= 0 ? args[pi + 1] : undefined,
});
