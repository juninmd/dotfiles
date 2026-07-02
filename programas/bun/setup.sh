#!/bin/bash
c='\e[32m'
r='tput sgr0'

echo -e "${c}Installing Bun (JS Runtime)...${r}"
curl -fsSL https://bun.sh/install | bash
echo -e "${c}Bun installed! Make sure to source your shell config.${r}"
