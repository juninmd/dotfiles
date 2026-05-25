#!/usr/bin/env bash
set -euo pipefail
echo "Installing helix..."
source "$PWD/programas/common/cargo_helper.sh"
install_cargo_crate helix-term --bin hx
