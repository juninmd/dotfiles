#!/bin/bash
c='\e[32m'
r='\e[0m'
# Google Cloud CLI
if ! command -v gcloud &> /dev/null; then
    echo -e "${c}Installing Google Cloud CLI...${r}"
    sudo apt-get install -y apt-transport-https ca-certificates gnupg curl # NOSONAR
    sudo mkdir -p /etc/apt/keyrings # NOSONAR
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/cloud.google.gpg # NOSONAR
    echo "deb [signed-by=/etc/apt/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list # NOSONAR
    sudo apt-get update # NOSONAR
    sudo apt-get install -y google-cloud-cli # NOSONAR
else
    echo -e "${c}gcloud already installed.${r}"
fi
