# ⚡ dotfiles

Ambiente de desenvolvimento reproduzível para **Windows, macOS e Linux**, com instalador oficial em TUI.

📖 **Docs:** <https://juninmd.github.io/dotfiles/> · ⬇️ **Download:** <https://juninmd.github.io/dotfiles/download>

## Instalar

```sh
# macOS / Linux
curl -fsSL https://juninmd.github.io/dotfiles/install.sh | sh
```

```powershell
# Windows
irm https://juninmd.github.io/dotfiles/install.ps1 | iex
```

O bootstrap baixa o binário da última release e confere o SHA-256 antes de executar. Simule sem instalar: `dotfiles --profile dev --dry-run`.

## Estrutura

| Caminho | O quê |
|---|---|
| `installer/` | Instalador TUI (TypeScript + Bun, binário único) e `catalog/catalog.json` |
| `docs/` | Site VitePress (`pnpm docs:dev`) |
| `programas/` | Scripts de setup por programa (Linux) |
| `setup-2026.sh`, `setup.sh` | Instaladores shell legados |

## Desenvolvimento

```sh
pnpm install && pnpm docs:dev        # site
cd installer && bun install && bun test && bun start --dry-run
```

Créditos: base inspirada em <https://github.com/shubhampathak/autosetup>.
