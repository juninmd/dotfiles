#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Yamlfmt (YAML formatter)
install_go_package github.com/google/yamlfmt/cmd/yamlfmt@latest yamlfmt
