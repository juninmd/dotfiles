#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Glab (GitLab CLI)
install_go_package gitlab.com/gitlab-org/cli/cmd/glab@latest glab
