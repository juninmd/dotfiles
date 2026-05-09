#!/usr/bin/env bash
source "$ROOT_DIR/programas/common/cargo_helper.sh"
c="\e[32m"
r="\e[0m"
echo -e "${c}Installing devbox (Portable Developer Environments)...${r}"
if ! command -v devbox &> /dev/null; then
    curl -fsSL https://get.jetpack.io/devbox | bash
    echo -e "${c}devbox installed.${r}"
else
    echo -e "${c}devbox already installed.${r}"
fi
