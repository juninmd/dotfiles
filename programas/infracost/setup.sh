#!/bin/bash
c='\e[32m'
r='\e[0m'
# Infracost (Cloud cost estimates)
if ! command -v infracost &> /dev/null; then
    printf "%b\n" "${c}Installing infracost...${r}"
    curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sudo sh
else
    printf "%b\n" "${c}infracost already installed.${r}"
fi
