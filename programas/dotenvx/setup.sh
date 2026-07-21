#!/bin/bash
c='\e[32m'
r='\e[0m'
# Dotenvx (Better dotenv)
if ! command -v dotenvx &> /dev/null; then
    echo -e "${c}Installing dotenvx...${r}"
    { curl -fsS https://dotenvx.sh/ -o /tmp/dotenvx_install.sh && sh /tmp/dotenvx_install.sh; } # NOSONAR
else
    echo -e "${c}dotenvx already installed.${r}"
fi
