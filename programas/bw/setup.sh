#!/bin/bash
echo -e "\e[32mInstalling Bitwarden CLI (bw)...\e[0m"
if command -v npm &> /dev/null; then
    sudo npm i -g @bitwarden/cli
else
    echo "npm not found. Please install Node.js/npm first."
fi
