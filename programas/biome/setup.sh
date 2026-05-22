#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
echo -e "${c}Installing biome...${r}"
curl -L https://github.com/biomejs/biome/releases/download/v1.9.4/biome-linux-x64 -o biome
chmod +x biome
sudo mv biome /usr/local/bin/biome
echo -e "${c}biome setup complete.${r}"
