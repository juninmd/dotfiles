#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Stern (Multi pod logs)
install_go_package github.com/stern/stern@latest stern
