#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Termdbms (Database TUI)
install_go_package github.com/mathaou/termdbms@latest termdbms
