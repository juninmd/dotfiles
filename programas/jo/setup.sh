#!/usr/bin/env bash
set -euo pipefail

# Cyberpunk/Synthwave color formatting
c="\e[38;2;255;126;219m" # Pink (#ff7edb)
r="\e[0m"               # Reset

echo -e "${c}Installing jo (JSON output utility)...${r}"

if ! command -v jo &> /dev/null; then
    sudo apt install -y jo # NOSONAR
else
    echo -e "${c}jo already installed.${r}"
fi
