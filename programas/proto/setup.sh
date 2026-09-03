#!/usr/bin/env bash
set -euo pipefail

log() {
  echo -e "\033[38;2;255;126;219m[\033[38;2;54;249;246m2026-setup\033[38;2;255;126;219m]\033[0m $1"
}

log "🚀 Instalando proto (Pluggable next-generation version manager)..."
curl -fsSL https://moonrepo.dev/install/proto.sh | /usr/bin/env bash
log "✅ proto instalado."
