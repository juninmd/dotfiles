#!/usr/bin/env bash

# Setup colors
c='\e[32m'
r='\e[0m'

if ! command -v zoxide &> /dev/null; then
    echo -e "${c}Installing zoxide...${r}"
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | /usr/bin/env sh
else
    echo -e "${c}zoxide already installed.${r}"
fi
