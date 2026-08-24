#!/usr/bin/env bash

c='\e[32m'
r='\e[0m'

if ! command -v micro >/dev/null 2>&1; then
    echo -e "${c}Installing micro...${r}"
    curl -sL https://getmic.ro | /usr/bin/env bash
    sudo mv micro /usr/local/bin/
else
    echo -e "${c}micro already installed.${r}"
fi
