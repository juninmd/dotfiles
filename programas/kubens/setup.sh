#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# kubens is already installed by kubectx, but memory says to add it, so let's just make it do the same or skip.
install_go_package github.com/ahmetb/kubectx/cmd/kubens@latest kubens
