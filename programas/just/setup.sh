#!/usr/bin/env sh
set -eu

echo "Installing just..."

. "$(dirname "$0")/../common/cargo_helper.sh"
install_cargo_crate just
