#!/usr/bin/env bash
set -e
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing ffuf...${r}"
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
install_go_package "github.com/ffuf/ffuf/v2@latest"
echo -e "${c}ffuf setup complete.${r}"
