#!/usr/bin/env bash
set -euo pipefail

c='\e[36m'
r='\e[0m'

echo -e "${c}Installing Ollama...${r}"
if ! command -v ollama &> /dev/null; then
    curl -fsSL https://ollama.com/install.sh | sh
    echo -e "${c}Ollama installed successfully!${r}"
else
    echo -e "${c}Ollama already installed.${r}"
fi

# Try to start the service
if command -v systemctl &> /dev/null; then
    sudo systemctl enable --now ollama || true
fi

echo -e "${c}Ollama setup complete.${r}"
