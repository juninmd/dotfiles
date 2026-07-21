#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'

# Devbox (Portable Developer Environments)
if ! command -v devbox &> /dev/null; then
    echo -e "${c}Installing devbox...${r}"
    curl -fsSL https://get.jetpack.io/devbox | bash # NOSONAR
else
    echo -e "${c}devbox already installed.${r}"
fi