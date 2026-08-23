#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Git-Town (High-level CLI for Git)
install_go_package github.com/git-town/git-town/v16@latest git-town
