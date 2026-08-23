#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Ncspot (Cross-platform Spotify client)
install_cargo_crate ncspot
