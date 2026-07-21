#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# shfmt (Shell parser, formatter, and interpreter)
install_go_package mvdan.cc/sh/v3/cmd/shfmt@latest shfmt
