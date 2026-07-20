#!/bin/bash
source "$(dirname "$0")/../common/cargo_helper.sh"
install_go_package "github.com/cli/cli/v2/cmd/gh@latest" "gh"
