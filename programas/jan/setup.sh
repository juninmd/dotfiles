#!/bin/bash
c="\e[32m"
r="\e[0m"
echo -e "${c}Installing Jan...${r}"
# Assuming it's downloaded as AppImage or via script.
if ! command -v jan &> /dev/null; then
    curl -fsSL https://raw.githubusercontent.com/janhq/jan/main/install.sh | bash
else
    echo -e "${c}jan already installed.${r}"
fi