#!/usr/bin/env sh
set -eu

echo "Installing helix..."

. "$(dirname "$0")/../common/cargo_helper.sh"
install_cargo_crate helix-term hx
