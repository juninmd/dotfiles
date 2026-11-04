#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '\e[36m[2026-setup]\e[0m %s\n' "$*"
}

log "Instalando hollywood..."
if command -v apt-get &> /dev/null; then
  sudo apt-get update -yqq || true
  sudo apt-get install -yqq hollywood
elif command -v dnf &> /dev/null; then
  sudo dnf install -y hollywood
elif command -v pacman &> /dev/null; then
  sudo pacman -S --noconfirm hollywood
else
  log "Gerenciador de pacotes não suportado para hollywood."
  (return 0 2>/dev/null) && return 1 || bash -c "exit 1"
fi

log "hollywood instalado com sucesso."
