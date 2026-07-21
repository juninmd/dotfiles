#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Sops (Secrets Management) - explicitly add if missing
install_go_package github.com/getsops/sops/v3/cmd/sops@latest sops
