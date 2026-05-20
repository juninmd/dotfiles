#!/usr/bin/env sh
set -eu

echo "Installing biome..."

if ! command -v biome > /dev/null 2>&1; then
  curl -L https://github.com/biomejs/biome/releases/download/v1.9.4/biome-linux-x64 -o biome
  chmod +x biome
  sudo mv biome /usr/local/bin/biome
fi
