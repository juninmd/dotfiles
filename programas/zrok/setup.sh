#!/bin/bash
c='\e[32m'
r='\e[0m'
# Zrok (Ngrok alternative)
if ! command -v zrok &> /dev/null; then
    printf "%b\n" "${c}Installing zrok...${r}"
    { curl -sSL https://raw.githubusercontent.com/openziti/zrok/main/install/setup.sh -o /tmp/zrok_install.sh && sudo bash /tmp/zrok_install.sh; }
else
    printf "%b\n" "${c}zrok already installed.${r}"
fi
