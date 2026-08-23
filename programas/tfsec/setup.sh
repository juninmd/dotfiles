#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Tfsec (Terraform security scanner)
install_go_package github.com/aquasecurity/tfsec/cmd/tfsec@latest tfsec
