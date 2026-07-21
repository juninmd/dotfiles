#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Mani (Multi-repository management)
install_go_package github.com/alajmo/mani@latest mani
