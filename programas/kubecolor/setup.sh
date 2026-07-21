#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Kubecolor (Colorized kubectl)
install_go_package github.com/kubecolor/kubecolor@latest kubecolor
