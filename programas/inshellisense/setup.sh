#!/bin/bash
c="\e[32m"
r="\e[0m"
echo -e "${c}Installing inshellisense...${r}"
if ! command -v inshellisense &> /dev/null; then
    if command -v npm &> /dev/null; then # NOSONAR
        sudo npm install -g @microsoft/inshellisense # NOSONAR
    else
        echo -e "${c}npm not found. Please install node first.${r}" # NOSONAR
    fi
else
    echo -e "${c}inshellisense already installed.${r}"
fi