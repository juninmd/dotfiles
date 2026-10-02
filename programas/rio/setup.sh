#!/usr/bin/env bash
set -euo pipefail

log() {
  printf "\033[38;2;255;126;219m[\033[38;2;54;249;246m2026-setup\033[38;2;255;126;219m]\033[0m %s\n" "$1"
}

log "🚀 Instalando rio (Hardware-accelerated GPU terminal emulator)..."
source "$(dirname "${BASH_SOURCE[0]}")/../common/cargo_helper.sh"
install_cargo_crate rio
log "✅ rio instalado."
