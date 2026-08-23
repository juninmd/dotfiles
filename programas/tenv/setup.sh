#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Tenv (OpenTofu, Terraform, Terragrunt version manager)
install_go_package github.com/tofuutils/tenv/v4/cmd/tenv@latest tenv
