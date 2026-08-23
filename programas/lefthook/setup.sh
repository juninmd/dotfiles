#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Lefthook (Git hooks manager)
install_go_package github.com/evilmartians/lefthook@latest lefthook
