#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing Obsidian...${r}"
LATEST_RELEASE=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | grep "browser_download_url.*_amd64.deb" | cut -d '"' -f 4)
if [ -z "$LATEST_RELEASE" ]; then
    LATEST_RELEASE="https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.12/obsidian_1.5.12_amd64.deb"
fi
wget -qO obsidian.deb "$LATEST_RELEASE"
sudo dpkg -i obsidian.deb || sudo apt-get install -f -y
rm obsidian.deb
echo -e "${c}Obsidian installed!${r}"
