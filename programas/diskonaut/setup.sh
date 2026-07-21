#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Diskonaut (Terminal disk space navigator)
install_cargo_crate diskonaut
