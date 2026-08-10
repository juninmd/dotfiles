#!/bin/bash
# Fallback or pipx install for aider-chat
if command -v pipx &> /dev/null; then
    pipx install aider-chat # NOSONAR
else
    python3 -m pip install --break-system-packages aider-chat # NOSONAR
fi
