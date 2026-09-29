#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Devbox (Portable Developer Environments)
if ! command -v devbox &> /dev/null; then
    printf "%b\n" "${c}Installing devbox...${r}"
    curl -fsSL https://get.jetpack.io/devbox | bash
else
    printf "%b\n" "${c}devbox already installed.${r}"
fi