#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$ROOT_DIR/programas/common/go_helper.sh"

echo "Installing dnote..."
install_go_package github.com/dnote/dnote@latest dnote
echo "dnote installed successfully."
