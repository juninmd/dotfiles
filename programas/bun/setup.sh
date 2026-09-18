#!/bin/bash
c='\e[32m'
r='tput sgr0'

printf "%b\n" "${c}Installing Bun (JS Runtime)...${r}"
curl -fsSL https://bun.sh/install | bash
printf "%b\n" "${c}Bun installed! Make sure to source your shell config.${r}"
