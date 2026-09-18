#!/bin/bash
c='\e[32m'
r='\e[0m'
# Helm (The Kubernetes Package Manager)
if ! command -v helm &> /dev/null; then
    printf "%b\n" "${c}Installing Helm...${r}"
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    rm get_helm.sh
else
    printf "%b\n" "${c}Helm already installed.${r}"
fi
