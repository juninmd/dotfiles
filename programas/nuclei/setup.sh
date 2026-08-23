#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Nuclei (Fast vulnerability scanner)
install_go_package github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest nuclei
