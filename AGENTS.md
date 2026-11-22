# AGENTS.md

Dotfiles: one-command setup of a developer machine (Linux, macOS, Windows). Two parts: an interactive installer in Bun/TypeScript (`installer/`) and one `setup.sh` per tool in `programas/`. Docs site: VitePress (`docs/`).

## Stack

- Installer: Bun, TypeScript (`installer/`, `bun.lock`).
- Docs: VitePress with pnpm (`package.json`, `pnpm-lock.yaml`).
- Tool modules: Bash (`programas/<id>/setup.sh`), shared helpers in `programas/common/`.

## Commands

```bash
cd installer && bun install --frozen-lockfile
cd installer && bun src/index.ts --help        # run the installer from source
cd installer && bun src/index.ts --profile dev --dry-run   # print the plan, run nothing
cd installer && bun test                       # unit tests (src/*.test.ts)
cd installer && bunx tsc --noEmit             # typecheck
cd installer && bun run build                  # single binary: dist/dotfiles

pnpm install --frozen-lockfile && pnpm docs:dev     # docs dev server
pnpm docs:build                                     # docs build (CI: docs.yml)
```

CI: `installer.yml` runs typecheck and tests from `installer/`. `docs.yml` runs the docs build. `setup.sh` and `setup-2026.sh` at the root run the module scripts without the binary.

## Structure

- `installer/src/`: CLI (`index.ts`, `args.ts`), planning (`plan.ts`), execution (`run.ts`), platform detection (`platform.ts`), UI (`ui.ts`). `installer/catalog/catalog.json` lists the tools.
- `programas/<id>/setup.sh`: install script per tool. Optional `config.yml`, `settings.json`, `starship.toml`, etc. next to it.
- `programas/common/`: shared helpers (`cargo_helper.sh`, `go_helper.sh`).
- `setup.sh`, `setup-2026.sh`: root entry points that run `programas/` without the binary (documented in `README.md`).
- `utils/generate-ssh.sh`: SSH key helper.
- `docs/`: VitePress site (`guide/`, `apps/`, `os/`), install scripts served from `docs/public/`.

## Conventions

- Development rules: max 150 lines per file, separation of concerns, every change passes tests and lint, sensitive data stays out of context.
- Plan -> Act -> Validate for every task. `GEMINI.md` is not in this repository.
- Commits: conventional, with scope, e.g. `fix(installer): ...` (see recent history).
- A new tool is a new folder `programas/<id>/` with `setup.sh`, plus an entry in `installer/catalog/catalog.json`.

<!-- base-actions-main-policy -->
## GitHub Actions — padrão obrigatório (@main)

- Referencie as actions internas sempre pelo branch, nunca por SHA:
  - `uses: juninmd/base-actions/<action>@main`
  - `uses: juninmd/base-actions/.github/workflows/<arquivo>.yml@main`
- Não fixe `@<sha>` em `juninmd/base-actions`: a atualização é centralizada no
  `main` e passa a valer no próximo run.
- PRs cujos checks não iniciam por billing/spending limit são mesclados pelo bot central
  `juninmd/base-actions/.github/workflows/auto-merge-billing-blocked.yml`.
  Para impedir o merge automático de um PR, aplique a label `do-not-merge`.

## Gotchas

- The compiled binary does not include `programas/`. Set `DOTFILES_DIR` to a clone when running it (`DOTFILES_DIR=~/dotfiles ./dotfiles`).
- `installer/catalog/catalog.json` is data read by the installer. Keep it in sync with `programas/`.
- Run `--dry-run` before a real install to see the plan.
