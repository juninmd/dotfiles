#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Kubectx and Kubens (Kubernetes context switching)
install_go_package github.com/ahmetb/kubectx/cmd/kubectx@latest kubectx
install_go_package github.com/ahmetb/kubectx/cmd/kubens@latest kubens
