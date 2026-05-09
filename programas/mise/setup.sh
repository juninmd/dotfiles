#!/usr/bin/env bash
source "$ROOT_DIR/programas/common/cargo_helper.sh"
c="\e[32m"
r="\e[0m"
echo -e "${c}Installing mise (Polyglot Tool Version Manager)...${r}"
if ! command -v mise &> /dev/null; then
    curl https://mise.jdx.dev/install.sh | bash
    echo -e "${c}mise installed.${r}"
else
    echo -e "${c}mise already installed.${r}"
fi
