#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$ROOT_DIR/programas/common/cargo_helper.sh"

echo "Installing dsq..."
install_go_package github.com/multiprocessio/dsq@latest dsq
echo "dsq installed successfully."
