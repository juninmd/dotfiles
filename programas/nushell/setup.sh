#!/usr/bin/env bash
set -euo pipefail
echo "Installing nushell..."
source "$PWD/programas/common/cargo_helper.sh"
install_cargo_crate nu
