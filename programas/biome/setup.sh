#!/usr/bin/env bash
set -euo pipefail
echo -e "\e[32mInstalling Biome...\e[0m"
curl -L https://github.com/biomejs/biome/releases/download/v1.9.4/biome-linux-x64 -o biome
chmod +x biome
sudo mv biome /usr/local/bin/biome