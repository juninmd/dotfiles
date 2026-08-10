#!/bin/bash
source "$(dirname "$0")/../common/cargo_helper.sh"
# Fallback or pipx install for aider-chat
if command -v pipx &> /dev/null; then
    pipx install aider-chat
else
    pip3 install --break-system-packages aider-chat
fi
