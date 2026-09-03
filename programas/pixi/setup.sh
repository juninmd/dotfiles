#!/usr/bin/env bash
set -euo pipefail

log() {
  printf "\033[38;2;255;126;219m[\033[38;2;54;249;246m2026-setup\033[38;2;255;126;219m]\033[0m %s\n" "$1"
}

log "🚀 Instalando pixi (Fast package manager for Python/C++)..."
curl --proto '=https' --tlsv1.2 -fsSL "https://pixi.sh/install.sh" | /usr/bin/env sh
log "✅ pixi instalado."
