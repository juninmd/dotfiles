#!/usr/bin/env sh
set -eu

echo "Installing pueue..."

. "$(dirname "$0")/../common/cargo_helper.sh"
install_cargo_crate pueue
