#!/usr/bin/env bash

# Setup colors
c='\e[32m'
r='\e[0m'

if ! command -v zoxide &> /dev/null; then
    printf "%b\n" "${c}Installing zoxide...${r}"
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | /usr/bin/env sh
else
    printf "%b\n" "${c}zoxide already installed.${r}"
fi
