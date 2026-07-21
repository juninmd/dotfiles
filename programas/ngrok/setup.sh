#!/bin/bash
c='\e[32m'
r='\e[0m'
# Ngrok (Unified Application Delivery Platform)
if ! command -v ngrok &> /dev/null; then
    echo -e "${c}Installing ngrok...${r}"
    curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo gpg --dearmor -o /usr/share/keyrings/ngrok.gpg # NOSONAR
    echo "deb [signed-by=/usr/share/keyrings/ngrok.gpg] https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list # NOSONAR
    sudo apt update # NOSONAR
    sudo apt install -y ngrok # NOSONAR
else
    echo -e "${c}ngrok already installed.${r}"
fi
