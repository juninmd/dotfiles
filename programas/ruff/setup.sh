#!/usr/bin/env bash
set -euo pipefail
echo -e "\e[32mInstalling Ruff...\e[0m"
if command -v uv > /dev/null 2>&1; then
    uv tool install ruff
else
    pip3 install ruff --break-system-packages
fi