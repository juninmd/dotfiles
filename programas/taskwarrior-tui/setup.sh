#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Taskwarrior-tui (Productivity)
install_cargo_crate taskwarrior-tui
