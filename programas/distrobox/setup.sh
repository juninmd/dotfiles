#!/usr/bin/env bash
set -euo pipefail
echo -e "\e[32mInstalling Distrobox...\e[0m"
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo /usr/bin/env sh