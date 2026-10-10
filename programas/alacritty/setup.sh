#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing alacritty...${r}"
sudo add-apt-repository ppa:aslatter/ppa -y
sudo apt update
sudo apt install -y alacritty
echo -e "${c}alacritty installed!${r}"
