#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Systemctl-tui (Systemd TUI)
install_cargo_crate systemctl-tui
