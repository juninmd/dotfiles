#!/usr/bin/env bash
set -euo pipefail

# Cyberpunk/Synthwave color formatting
c="\e[38;2;255;126;219m" # Pink (#ff7edb)
r="\e[0m"               # Reset

source "$(dirname "$0")/../common/cargo_helper.sh"

echo -e "${c}Installing k6 (Modern load testing tool)...${r}"

if ! command -v k6 &> /dev/null; then
    install_go_package go.k6.io/k6@latest k6
else
    echo -e "${c}k6 already installed.${r}"
fi
