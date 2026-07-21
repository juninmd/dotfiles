#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# sqlc (Compile SQL to type-safe code)
install_go_package github.com/sqlc-dev/sqlc/cmd/sqlc@latest sqlc
