#!/bin/bash
c='\e[32m'
r='\e[0m'
# dolt (Git for data)
if ! command -v dolt &> /dev/null; then
    echo -e "${c}Installing dolt...${r}"
    curl -sL https://github.com/dolthub/dolt/releases/latest/download/install.sh -o /tmp/dolt_install.sh && sudo bash /tmp/dolt_install.sh && rm /tmp/dolt_install.sh
else
    echo -e "${c}dolt already installed.${r}"
fi
