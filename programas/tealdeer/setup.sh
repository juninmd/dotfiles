#!/usr/bin/env sh
set -eu

echo "Installing tealdeer..."

. "$(dirname "$0")/../common/cargo_helper.sh"
install_cargo_crate tealdeer tldr
if command -v tldr > /dev/null 2>&1; then tldr --update > /dev/null 2>&1 || true; fi
