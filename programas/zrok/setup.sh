#!/bin/bash
c='\e[32m'
r='\e[0m'
# Zrok (Ngrok alternative)
if ! command -v zrok &> /dev/null; then
    echo -e "${c}Installing zrok...${r}"
    { curl -sSL https://raw.githubusercontent.com/openziti/zrok/main/install/setup.sh -o /tmp/zrok_install.sh && sudo bash /tmp/zrok_install.sh; } # NOSONAR
else
    echo -e "${c}zrok already installed.${r}"
fi
