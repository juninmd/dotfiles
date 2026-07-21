#!/bin/bash
c='\e[32m'
r='\e[0m'
# Cloudflared (Localhost tunneling)
if ! command -v cloudflared &> /dev/null; then
    echo -e "${c}Installing cloudflared...${r}"
    sudo wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared # NOSONAR
    sudo chmod +x /usr/local/bin/cloudflared
else
    echo -e "${c}cloudflared already installed.${r}"
fi
