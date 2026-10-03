#!/usr/bin/env bash
set -euo pipefail
if ! command -v pipx &> /dev/null; then
    sudo apt-get install -y pipx
    pipx ensurepath
fi
pipx install iredis
