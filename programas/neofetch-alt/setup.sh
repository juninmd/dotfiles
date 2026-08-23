#!/bin/bash
set -euo pipefail
echo "Installing neofetch alternative (fastfetch)..."
sudo add-apt-repository -y ppa:zhanghua/fastfetch
sudo apt update
sudo apt install -y fastfetch
echo "fastfetch successfully installed!"
