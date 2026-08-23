#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# JQP (TUI for jq)
install_go_package github.com/noahgorstein/jqp@latest jqp
