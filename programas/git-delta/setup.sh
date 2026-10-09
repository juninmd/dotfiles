#!/usr/bin/env bash
printf "%b\n" "Installing git-delta..."
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -f "$SCRIPT_DIR/../common/cargo_helper.sh" ]; then
    source "$SCRIPT_DIR/../common/cargo_helper.sh"
    install_cargo_crate git-delta
else
    cargo install git-delta
fi
