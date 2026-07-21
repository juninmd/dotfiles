#!/bin/bash
c='\e[32m'
r='\e[0m'
# Trivy (Container security scanner)
if ! command -v trivy &> /dev/null; then
    echo -e "${c}Installing trivy...${r}"
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo gpg --dearmor -o /etc/apt/keyrings/trivy.gpg
    echo "deb [signed-by=/etc/apt/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list
    sudo apt-get update
    sudo apt-get install -y trivy
else
    echo -e "${c}trivy already installed.${r}"
fi
