#!/usr/bin/env bash
set -euo pipefail

c='\e[36m'
r='\e[0m'

echo -e "${c}Installing Claude Code (Anthropic)...${r}"

if ! command -v npm &> /dev/null; then
    echo -e "${c}npm not found. Please install Node.js/npm first.${r}"
    exit 1
fi

if ! command -v claude &> /dev/null; then
    sudo npm install -g @anthropic-ai/claude-code
    echo -e "${c}Claude Code installed successfully!${r}"
else
    echo -e "${c}Claude Code already installed.${r}"
fi

echo -e "${c}Claude Code setup complete. Run 'claude' to start.${r}"
