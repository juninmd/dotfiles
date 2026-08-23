#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Hwatch (A modern alternative to the watch command)
install_cargo_crate hwatch
