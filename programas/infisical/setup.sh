#!/bin/bash
echo -e "\e[32mInstalling Infisical CLI...\e[0m"
curl -1sLf "https://dl.cloudsmith.io/public/infisical/infisical-cli/setup.deb.sh" | sudo -E bash # NOSONAR
sudo apt-get update && sudo apt-get install -y infisical
