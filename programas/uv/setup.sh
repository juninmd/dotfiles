#!/usr/bin/env bash
set -euo pipefail

c='\e[36m'
r='\e[0m'

printf "%b\n" "${c}Installing uv (Astral)...${r}"
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | env PATH="$PATH" /bin/bash
    printf "%b\n" "${c}uv installed successfully!${r}"
else
    printf "%b\n" "${c}uv already installed.${r}"
fi

printf "%b\n" "${c}uv setup complete.${r}"
