#!/bin/bash
echo -e "\e[32mInstalling Vault...\e[0m"
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
if command -v lsb_release &> /dev/null; then
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
else
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com focal main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
fi
sudo apt update && sudo apt install -y vault
