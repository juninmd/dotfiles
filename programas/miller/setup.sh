#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Miller (Data processing)
install_go_package github.com/johnkerl/miller/cmd/mlr@latest mlr
