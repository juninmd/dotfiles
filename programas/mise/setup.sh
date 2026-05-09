#!/usr/bin/env bash

# Setup colors
c='\e[32m'
r='\e[0m'

if ! command -v mise &> /dev/null; then
    echo -e "${c}Installing mise...${r}"
    curl https://mise.jdx.dev/install.sh | sh
else
    echo -e "${c}mise already installed.${r}"
fi
