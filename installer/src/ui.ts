import * as p from "@clack/prompts";
import pc from "picocolors";
import { buildPlan, resolveModules } from "./plan";
import { runCommand } from "./run";
import type { Catalog, OS } from "./types";

const OS_LABEL: Record<OS, string> = { linux: "Linux", macos: "macOS", windows: "Windows" };

export interface Options { dryRun: boolean; profile?: string; yes: boolean }

function bail(v: unknown): asserts v is Exclude<typeof v, symbol> {
  if (p.isCancel(v)) { p.cancel("Cancelado. Nada foi alterado."); process.exit(0); }
}

export async function start(catalog: Catalog, os: OS, opts: Options): Promise<void> {
  console.clear();
  p.intro(pc.bgMagenta(pc.black(" dotfiles ")) + pc.dim(`  instalador oficial · ${OS_LABEL[os]}`));
  if (opts.dryRun) p.log.warn("Modo --dry-run: nada será instalado.");

  let ids: string[];
  if (opts.profile) {
    const prof = catalog.profiles[opts.profile];
    if (!prof) { p.cancel(`Perfil desconhecido: ${opts.profile}`); process.exit(2); }
    ids = prof.modules;
  } else {
    const choice = await p.select({
      message: "Escolha um perfil",
      options: [
        ...Object.entries(catalog.profiles).map(([k, v]) => ({ value: k, label: v.name, hint: `${v.desc} · ${v.modules.length} apps` })),
        { value: "custom", label: "Personalizado", hint: "escolher módulo a módulo" },
      ],
    });
    bail(choice);
    if (choice === "custom") {
      const available = catalog.modules.filter((m) => m.install[os]);
      const picked = await p.autocompleteMultiselect({
        message: `Digite para filtrar · espaço marca · enter confirma (${available.length} módulos em ${OS_LABEL[os]})`,
        options: available.map((m) => ({ value: m.id, label: m.name, hint: `${m.category} · ${m.desc}` })),
      });
      bail(picked);
      ids = picked as string[];
    } else ids = catalog.profiles[choice as string]!.modules;
  }

  const { commands, skipped } = buildPlan(resolveModules(catalog, ids), os);
  p.note(commands.map((c) => `${pc.cyan("›")} ${c.label}`).join("\n") || "(vazio)", `Plano · ${commands.length} passos`);
  if (skipped.length) p.log.info(`Sem suporte em ${OS_LABEL[os]}: ${skipped.map((m) => m.name).join(", ")}`);

  if (!opts.yes && !opts.dryRun) {
    const ok = await p.confirm({ message: "Executar o plano?" });
    bail(ok);
    if (!ok) { p.cancel("Nada foi alterado."); return; }
  }

  const failed: string[] = [];
  for (const c of commands) {
    const s = p.spinner();
    s.start(`Instalando ${c.moduleId}`);
    const r = await runCommand(c, opts.dryRun);
    if (r.ok) s.stop(`${pc.green("✔")} ${c.moduleId}`);
    else { s.stop(`${pc.red("✘")} ${c.moduleId} (exit ${r.code})`); failed.push(c.moduleId); }
  }
  if (failed.length) { p.outro(pc.red(`Falhou: ${failed.join(", ")}`)); process.exit(1); }
  p.outro(pc.green(opts.dryRun ? "Simulação concluída ✨" : "Tudo pronto ✨ Reinicie o terminal."));
}
