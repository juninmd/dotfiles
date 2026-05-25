#!/usr/bin/env bash
set -euo pipefail
echo "Installing hyperfine..."
source "$PWD/programas/common/cargo_helper.sh"
install_cargo_crate hyperfine
