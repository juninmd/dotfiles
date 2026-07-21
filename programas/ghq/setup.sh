#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# GHQ (Remote repository manager)
install_go_package github.com/x-motemen/ghq@latest ghq
