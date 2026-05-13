#!/usr/bin/env bash
set -e

c="\e[36m"
r="\e[0m"

if ! command -v mise &> /dev/null; then
    echo -e "${c}Installing mise...${r}"
    curl https://mise.jdx.dev/install.sh | sh
    echo -e "${c}mise setup complete.${r}"
else
    echo -e "${c}mise already installed.${r}"
fi
