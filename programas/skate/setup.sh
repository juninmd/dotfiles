#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Skate (Personal Key Value Store)
install_go_package github.com/charmbracelet/skate@latest skate
