#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Gtt (Google Translate TUI)
install_go_package github.com/eeeXun/gtt@latest gtt
