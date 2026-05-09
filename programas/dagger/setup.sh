#!/usr/bin/env bash
source "$ROOT_DIR/programas/common/cargo_helper.sh"
c="\e[32m"
r="\e[0m"
echo -e "${c}Installing dagger (Programmable CI/CD engine)...${r}"
if ! command -v dagger &> /dev/null; then
    curl -fsSL https://dl.dagger.io/dagger/install.sh | sudo bash
    echo -e "${c}dagger installed.${r}"
else
    echo -e "${c}dagger already installed.${r}"
fi
