#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing Obsidian...${r}"
LATEST_RELEASE=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | grep -o 'https://[^" ]*_amd64.deb' | head -n 1)
if [ -z "$LATEST_RELEASE" ]; then
    LATEST_RELEASE="https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.12/obsidian_1.5.12_amd64.deb"
fi
wget -qO obsidian.deb "$LATEST_RELEASE"
sudo apt install -y ./obsidian.deb
rm obsidian.deb
echo -e "${c}Obsidian installed!${r}"
