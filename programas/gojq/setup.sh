#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# gojq (Pure Go implementation of jq)
install_go_package github.com/itchyny/gojq/cmd/gojq@latest gojq
