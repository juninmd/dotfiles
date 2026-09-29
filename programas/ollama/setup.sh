#!/usr/bin/env bash
set -euo pipefail

c='\e[36m'
r='\e[0m'

printf "%b\n" "${c}Installing Ollama...${r}"
if ! command -v ollama &> /dev/null; then
    curl -fsSL https://ollama.com/install.sh | sh
    printf "%b\n" "${c}Ollama installed successfully!${r}"
else
    printf "%b\n" "${c}Ollama already installed.${r}"
fi

# Try to start the service
if command -v systemctl &> /dev/null; then
    sudo systemctl enable --now ollama || true
fi

printf "%b\n" "${c}Ollama setup complete.${r}"
