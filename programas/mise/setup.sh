#!/usr/bin/env bash

c="\033[1;36m"
r="\033[0m"

echo -e "${c}Installing mise...${r}"
if ! command -v mise &> /dev/null; then
    curl https://mise.jdx.dev/install.sh | sh
    echo -e "${c}mise installed successfully.${r}"
else
    echo -e "${c}mise already installed.${r}"
fi
