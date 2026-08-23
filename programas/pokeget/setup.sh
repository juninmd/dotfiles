#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Pokeget (Terminal Pokemon)
install_go_package github.com/talwat/pokeget@latest pokeget
