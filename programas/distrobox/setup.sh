#!/usr/bin/env bash
source "$(dirname "$0")/../common/common.sh"
echo -e "${c}Installing distrobox...${r}"
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo /usr/bin/env sh
echo -e "${c}distrobox setup complete.${r}"
