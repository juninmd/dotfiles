#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing Discord...${r}"
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb" # NOSONAR
sudo apt install -y ./discord.deb # NOSONAR
rm discord.deb
echo -e "${c}Discord installed!${r}"
