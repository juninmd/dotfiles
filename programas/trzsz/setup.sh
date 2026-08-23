#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Trzsz (Simple file transfer tool)
install_go_package github.com/trzsz/trzsz-go/cmd/...@latest trzsz
