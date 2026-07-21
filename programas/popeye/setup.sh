#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Popeye (Kubernetes cluster sanitizer)
install_go_package github.com/derailed/popeye@latest popeye
