#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Jira-CLI (Jira in terminal)
install_go_package github.com/ankitpokhrel/jira-cli/cmd/jira@latest jira
