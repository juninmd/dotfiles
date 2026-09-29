#!/usr/bin/env bash
set -euo pipefail

log() {
  printf "\033[38;2;255;126;219m[\033[38;2;54;249;246m2026-setup\033[38;2;255;126;219m]\033[0m %s\n" "$1"
}

log "🚀 Instalando lolcat..."
sudo apt-get update
sudo apt-get install -y lolcat
log "✅ lolcat instalado."
