#!/usr/bin/env bash
set -e

c="\e[36m"
r="\e[0m"

if ! command -v devbox &> /dev/null; then
    echo -e "${c}Installing devbox...${r}"
    curl -fsSL https://get.jetpack.io/devbox | bash
    echo -e "${c}devbox setup complete.${r}"
else
    echo -e "${c}devbox already installed.${r}"
fi
