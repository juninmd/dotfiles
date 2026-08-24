#!/usr/bin/env bash

c='\e[32m'
r='\e[0m'

if ! command -v micro >/dev/null 2>&1; then
    echo -e "${c}Installing micro...${r}"
    TMP_SCRIPT=$(mktemp)
    if curl -sL https://getmic.ro -o "$TMP_SCRIPT"; then
        bash "$TMP_SCRIPT"
        rm "$TMP_SCRIPT"
        if [ -f "micro" ]; then
            sudo mv micro /usr/local/bin/
        fi
    else
        echo -e "\e[31mFailed to download micro installer.\e[0m"
        rm -f "$TMP_SCRIPT"
    fi
else
    echo -e "${c}micro already installed.${r}"
fi
