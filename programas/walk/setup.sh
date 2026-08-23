#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Walk (Terminal Navigator)
install_go_package github.com/antonmedv/walk@latest walk
