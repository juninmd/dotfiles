#!/usr/bin/env sh
set -eu

echo "Installing broot..."

. "$(dirname "$0")/../common/cargo_helper.sh"
install_cargo_crate broot
if command -v broot > /dev/null 2>&1; then broot --install; fi
