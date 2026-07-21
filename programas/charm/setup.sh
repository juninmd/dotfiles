#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Charm (The Charm Tool)
install_go_package github.com/charmbracelet/charm@latest charm
