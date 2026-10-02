#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

if ! command -v k8sgpt &> /dev/null; then
    printf "%b\n" "${c}Installing k8sgpt...${r}"
    sudo eget k8sgpt-ai/k8sgpt --asset "Linux_x86_64.tar.gz" --file k8sgpt --to /usr/local/bin/k8sgpt
else
    printf "%b\n" "${c}k8sgpt already installed.${r}"
fi
