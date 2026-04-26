#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$ROOT_DIR/programas/common/cargo_helper.sh"

echo "Installing atac..."
install_cargo_crate atac
echo "atac installed successfully."
