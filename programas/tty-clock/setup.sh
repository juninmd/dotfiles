#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '\e[36m[2026-setup]\e[0m %s\n' "$*"
}

log "Instalando tty-clock..."
if command -v apt-get &> /dev/null; then
  sudo apt-get update -yqq || true
  sudo apt-get install -yqq tty-clock
elif command -v dnf &> /dev/null; then
  sudo dnf install -y tty-clock
elif command -v pacman &> /dev/null; then
  sudo pacman -S --noconfirm tty-clock
else
  log "Gerenciador de pacotes não suportado para tty-clock."
  # Use return instead of exit if sourced, else exit
  (return 0 2>/dev/null) && return 1 || bash -c "exit 1"
fi

log "tty-clock instalado com sucesso."
