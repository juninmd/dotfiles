#!/usr/bin/env bash

# Setup colors
c='\e[32m'
r='\e[0m'

if ! command -v devbox &> /dev/null; then
    echo -e "${c}Installing devbox...${r}"
    curl -fsSL https://get.jetpack.io/devbox | bash
else
    echo -e "${c}devbox already installed.${r}"
fi
