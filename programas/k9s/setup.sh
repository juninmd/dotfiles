#!/bin/bash
set -e
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing k9s...${r}"
sudo snap install k9s || true
echo -e "${c}k9s setup complete.${r}"
