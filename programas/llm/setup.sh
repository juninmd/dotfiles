#!/usr/bin/env bash
set -euo pipefail
echo -e "\e[32mInstalling LLM...\e[0m"
if command -v uv > /dev/null 2>&1; then
    uv tool install llm
else
    pip3 install llm --break-system-packages
fi