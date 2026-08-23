#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Freeze (Code Screenshots)
install_go_package github.com/charmbracelet/freeze@latest freeze
