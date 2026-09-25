#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$ROOT_DIR/programas/common/go_helper.sh"

echo "Installing gaze..."
install_go_package github.com/wtetsu/gaze/cmd/gaze@latest gaze
echo "gaze installed successfully."
