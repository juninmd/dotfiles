#!/usr/bin/env bash
set -euo pipefail

c='\e[36m'
r='\e[0m'

echo -e "${c}Installing uv (Astral)...${r}"
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | env PATH="$PATH" /bin/bash
    echo -e "${c}uv installed successfully!${r}"
else
    echo -e "${c}uv already installed.${r}"
fi

echo -e "${c}uv setup complete.${r}"
