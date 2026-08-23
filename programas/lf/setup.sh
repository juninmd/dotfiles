#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# lf (Fast terminal file manager)
install_go_package github.com/gokcehan/lf@latest lf
