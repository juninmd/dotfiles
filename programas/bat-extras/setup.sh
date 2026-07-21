#!/bin/bash
c='\e[32m'
r='\e[0m'
# Bat-extras (Bash scripts that integrate bat with various command line tools)
if ! command -v batman &> /dev/null; then
    echo -e "${c}Installing bat-extras...${r}"
    curl -fsSL https://raw.githubusercontent.com/eth-p/bat-extras/master/build.sh | sudo bash -s -- --install
else
    echo -e "${c}bat-extras already installed.${r}"
fi
