#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Tt (Typing test in terminal)
install_go_package github.com/lemnos/tt@latest tt
