#!/bin/bash
c='\e[32m'
r='tput sgr0'

echo -e "${c}Installing LazyGit...${r}"

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
# Fallback if grep -P is not supported
if [ -z "$LAZYGIT_VERSION" ]; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v([^"]+)".*/\1/')
fi

echo "Downloading LazyGit v${LAZYGIT_VERSION}..."
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit lazygit.tar.gz

echo -e "${c}LazyGit installed!${r}"
