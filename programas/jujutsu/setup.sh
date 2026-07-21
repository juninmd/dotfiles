#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Jujutsu (jj - Git alternative)
install_cargo_crate jj-cli jj
