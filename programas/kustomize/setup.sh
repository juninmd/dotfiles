#!/bin/bash
c='\e[32m'
r='\e[0m'
# Kustomize (Kubernetes native configuration management)
if ! command -v kustomize &> /dev/null; then
    echo -e "${c}Installing Kustomize...${r}"
    (
        cd "$(mktemp -d)"
        curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
        sudo mv kustomize /usr/local/bin/
    )
else
    echo -e "${c}Kustomize already installed.${r}"
fi
