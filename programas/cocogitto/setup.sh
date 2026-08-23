#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Cocogitto (A conventional commits toolkit)
install_cargo_crate cocogitto cog
