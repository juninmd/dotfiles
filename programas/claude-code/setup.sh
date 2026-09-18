#!/usr/bin/env bash
set -euo pipefail

c='\e[36m'
r='\e[0m'

printf "%b\n" "${c}Installing Claude Code (Anthropic)...${r}"

if ! command -v npm &> /dev/null; then
    printf "%b\n" "${c}npm not found. Please install Node.js/npm first.${r}"
    exit 1
fi

if ! command -v claude &> /dev/null; then
    sudo npm install -g @anthropic-ai/claude-code
    printf "%b\n" "${c}Claude Code installed successfully!${r}"
else
    printf "%b\n" "${c}Claude Code already installed.${r}"
fi

printf "%b\n" "${c}Claude Code setup complete. Run 'claude' to start.${r}"
