#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# USQL (Universal SQL Client)
install_go_package github.com/xo/usql@latest usql
