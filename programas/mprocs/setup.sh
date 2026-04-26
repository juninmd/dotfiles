#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$ROOT_DIR/programas/common/cargo_helper.sh"

echo "Installing mprocs..."
install_cargo_crate mprocs
echo "mprocs installed successfully."
