#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Actionlint (Static checker for GitHub Actions)
install_go_package github.com/rhysd/actionlint/cmd/actionlint@latest actionlint
