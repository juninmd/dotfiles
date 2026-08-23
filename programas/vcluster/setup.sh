#!/bin/bash
c='\e[32m'
r='\e[0m'
# vcluster (Virtual Kubernetes clusters)
if ! command -v vcluster &> /dev/null; then
    echo -e "${c}Installing vcluster...${r}"
    sudo eget loft-sh/vcluster --to /usr/local/bin/vcluster
else
    echo -e "${c}vcluster already installed.${r}"
fi
