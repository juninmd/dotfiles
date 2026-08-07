#!/bin/bash
echo -e "\e[32mInstalling Terragrunt...\e[0m"
wget https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_amd64 -O terragrunt
chmod +x terragrunt
sudo mv terragrunt /usr/local/bin/
