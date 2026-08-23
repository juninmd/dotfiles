#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Melt (SSH key backup and restore)
install_go_package github.com/charmbracelet/melt@latest melt
