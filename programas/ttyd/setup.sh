#!/bin/bash
echo -e "\e[32mInstalling ttyd...\e[0m"
sudo apt-get update && sudo apt-get install -y ttyd || {
    echo "ttyd package not found, falling back to manual install"
    wget https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 -O ttyd # NOSONAR
    chmod +x ttyd
    sudo mv ttyd /usr/local/bin/
}
