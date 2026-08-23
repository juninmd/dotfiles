#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Ctop (Top-like interface for container metrics)
install_go_package github.com/bcicen/ctop@latest ctop
