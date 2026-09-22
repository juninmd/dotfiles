#!/usr/bin/env bash
set -euo pipefail
c="\e[32m"
r="\e[0m"
echo -e "${c}Installing kew...${r}"
if ! command -v kew &> /dev/null; then
    wget -qO /tmp/kew https://github.com/ravachol/kew/releases/latest/download/kew-linux
    chmod +x /tmp/kew
    sudo mv /tmp/kew /usr/local/bin/kew
fi
