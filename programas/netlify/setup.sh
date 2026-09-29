#!/bin/bash
printf "%b\n" "\e[32mInstalling Netlify CLI...\e[0m"
if command -v npm &> /dev/null; then
    sudo npm i -g netlify-cli
else
    echo "npm not found. Please install Node.js/npm first."
fi
