#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Spotify-TUI (Spotify client in terminal)
install_cargo_crate spotify-tui spt
