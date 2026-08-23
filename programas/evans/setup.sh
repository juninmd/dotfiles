#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Evans (Interactive gRPC client)
install_go_package github.com/ktr0731/evans@latest evans
