#!/bin/bash
c='\e[32m'
r='\e[0m'
printf "%b\n" "${c}Installing Zed Editor...${r}"
curl -f https://zed.dev/install.sh | sh
printf "%b\n" "${c}Zed Editor installed successfully!${r}"
