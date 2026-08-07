#!/bin/bash
echo -e "\e[32mInstalling ArgoCD CLI...\e[0m"
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 # NOSONAR
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
