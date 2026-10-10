#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing lazysql...${r}"
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/go_helper.sh"
install_go_package github.com/jorgerojas26/lazysql@latest
echo -e "${c}lazysql installed!${r}"
