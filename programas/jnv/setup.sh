#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Jnv (Interactive JQ filter)
install_cargo_crate jnv
