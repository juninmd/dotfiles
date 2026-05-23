#!/usr/bin/env bash
set -euo pipefail
echo "Installing pueue..."
source "$PWD/programas/common/cargo_helper.sh"
install_cargo_crate pueue
