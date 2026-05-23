#!/usr/bin/env bash
set -euo pipefail
echo "Installing just..."
source "$PWD/programas/common/cargo_helper.sh"
install_cargo_crate just
