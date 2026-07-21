#!/bin/bash
c='\e[32m'
r='\e[0m'
# Kubectl
if ! command -v kubectl &> /dev/null; then
    echo -e "${c}Installing kubectl...${r}"
    sudo apt-get update # NOSONAR
    sudo apt-get install -y apt-transport-https ca-certificates curl # NOSONAR
    sudo mkdir -p /etc/apt/keyrings # NOSONAR
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg # NOSONAR
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list # NOSONAR
    sudo apt-get update # NOSONAR
    sudo apt-get install -y kubectl # NOSONAR
else
    echo -e "${c}kubectl already installed.${r}"
fi
