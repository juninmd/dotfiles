#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "[gaze setup] $*"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="$(dirname "$SCRIPT_DIR")/common"

if [[ -f "$COMMON_DIR/go_helper.sh" ]]; then
  source "$COMMON_DIR/go_helper.sh"
else
  log "Warning: $COMMON_DIR/go_helper.sh not found. Proceeding with direct go install."
  go install github.com/wturrell/gaze@latest
fi

log "Installing gaze..."
install_go_package "github.com/wturrell/gaze@latest" "gaze" || go install github.com/wturrell/gaze@latest
log "gaze installation complete."
