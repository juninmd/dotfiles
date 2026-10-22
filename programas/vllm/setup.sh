#!/usr/bin/env bash
set -euo pipefail
if command -v pipx &> /dev/null; then
    pipx install vllm
else
    echo "pipx is not installed. Please install pipx before continuing."
    exit 1
fi
