#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Age (Modern encryption tool)
install_go_package filippo.io/age/cmd/...@latest age
