#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Bore-cli (Localhost tunneling tool)
install_cargo_crate bore-cli bore
