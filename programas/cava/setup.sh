#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '\e[36m[2026-setup]\e[0m %s\n' "$*"
}

log "Instalando cava..."
if command -v apt-get &> /dev/null; then
  sudo apt-get update -yqq || true
  sudo apt-get install -yqq cava
elif command -v dnf &> /dev/null; then
  sudo dnf install -y cava
elif command -v pacman &> /dev/null; then
  sudo pacman -S --noconfirm cava
else
  log "Gerenciador de pacotes não suportado para cava."
  (return 0 2>/dev/null) && return 1 || bash -c "exit 1"
fi

log "cava instalado com sucesso."
