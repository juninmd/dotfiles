#!/bin/bash
c='\e[32m'
r='\e[0m'
# vcluster (Virtual Kubernetes clusters)
if ! command -v vcluster &> /dev/null; then
    printf "%b\n" "${c}Installing vcluster...${r}"
    sudo eget loft-sh/vcluster --to /usr/local/bin/vcluster
else
    printf "%b\n" "${c}vcluster already installed.${r}"
fi
