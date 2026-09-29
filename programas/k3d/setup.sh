#!/bin/bash
c='\e[32m'
r='\e[0m'
# K3d (Lightweight Kubernetes in Docker)
if ! command -v k3d &> /dev/null; then
    printf "%b\n" "${c}Installing k3d...${r}"
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
    printf "%b\n" "${c}k3d already installed.${r}"
fi
