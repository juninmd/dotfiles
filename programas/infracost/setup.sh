#!/bin/bash
c='\e[32m'
r='\e[0m'
# Infracost (Cloud cost estimates)
if ! command -v infracost &> /dev/null; then
    echo -e "${c}Installing infracost...${r}"
    curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sudo sh
else
    echo -e "${c}infracost already installed.${r}"
fi
