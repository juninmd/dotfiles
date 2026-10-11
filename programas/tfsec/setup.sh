#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$ROOT_DIR/programas/common/go_helper.sh"

echo "Installing tfsec..."
install_go_package github.com/aquasecurity/tfsec/cmd/tfsec@latest tfsec
echo "tfsec installed successfully."
