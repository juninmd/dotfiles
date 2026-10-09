#!/usr/bin/env bash
printf "%b\n" "Installing pypipe..."
if command -v pipx &> /dev/null; then
    pipx install pypipe
else
    pip3 install pypipe --break-system-packages
fi
