#!/usr/bin/env bash

c="\033[1;36m"
r="\033[0m"

echo -e "${c}Installing devbox...${r}"
if ! command -v devbox &> /dev/null; then
    curl -fsSL https://get.jetpack.io/devbox | bash
    echo -e "${c}devbox installed successfully.${r}"
else
    echo -e "${c}devbox already installed.${r}"
fi
