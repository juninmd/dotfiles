#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing nvtop...${r}"
sudo apt update
sudo apt install -y nvtop
echo -e "${c}nvtop installed!${r}"
