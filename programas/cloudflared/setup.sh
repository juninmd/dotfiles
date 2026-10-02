#!/bin/bash
c='\e[32m'
r='\e[0m'
# Cloudflared (Localhost tunneling)
if ! command -v cloudflared &> /dev/null; then
    printf "%b\n" "${c}Installing cloudflared...${r}"
    sudo wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared
    sudo chmod +x /usr/local/bin/cloudflared
else
    printf "%b\n" "${c}cloudflared already installed.${r}"
fi
