#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$ROOT_DIR/programas/common/go_helper.sh"

echo "Installing terragrunt..."
install_go_package github.com/gruntwork-io/terragrunt/cmd/terragrunt@latest terragrunt
echo "terragrunt installed successfully."
