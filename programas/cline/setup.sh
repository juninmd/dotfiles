#!/usr/bin/env bash
echo -e "\e[32mInstalling Cline...\e[0m"
if command -v npm &> /dev/null; then
    sudo npm install -g @cline/cli
else
    echo "npm not found. Skipping."
fi
