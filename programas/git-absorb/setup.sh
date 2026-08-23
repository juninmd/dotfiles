#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Git-absorb (Automatically absorb git commit changes)
install_cargo_crate git-absorb
