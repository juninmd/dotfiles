#!/usr/bin/env bash
set -e
c="\033[1;36m"
r="\033[0m"
source "$ROOT_DIR/programas/common/cargo_helper.sh" 2>/dev/null || true
echo -e "${c}Installing biome...${r}"
curl -L https://github.com/biomejs/biome/releases/download/v1.9.4/biome-linux-x64 -o biome
chmod +x biome
sudo mv biome /usr/local/bin/biome
