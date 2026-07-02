#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$ROOT_DIR/programas/common/cargo_helper.sh"

echo "Installing t-rec..."
install_cargo_crate t-rec
echo "t-rec installed successfully."
