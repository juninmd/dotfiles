#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# SCC (Sloc Cloc and Code - extremely fast code counter)
install_go_package github.com/boyter/scc/v3@latest scc
