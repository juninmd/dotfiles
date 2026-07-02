#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing Discord...${r}"
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo apt install -y ./discord.deb
rm discord.deb
echo -e "${c}Discord installed!${r}"
