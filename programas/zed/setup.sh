#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing Zed Editor...${r}"
curl -f https://zed.dev/install.sh | sh # NOSONAR
echo -e "${c}Zed Editor installed successfully!${r}"
