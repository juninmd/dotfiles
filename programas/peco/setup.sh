#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Peco (Interactive filtering tool)
install_go_package github.com/peco/peco/cmd/peco@latest peco
