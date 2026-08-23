#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Cheat (Create and view interactive cheatsheets on the command-line)
install_go_package github.com/cheat/cheat/cmd/cheat@latest cheat
