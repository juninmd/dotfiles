#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m'  # Reset Color

echo -e "${c}Installing Poetry (Python dependency management)...${r}"

if ! command -v poetry &> /dev/null; then
    curl -sSL https://install.python-poetry.org | python3 -

    # Add poetry to path for current session if possible
    export PATH="$HOME/.local/bin:$PATH"

    # Check installation
    if command -v poetry &> /dev/null; then
        echo -e "${c}Poetry installed successfully.${r}"
        poetry --version
    else
        echo -e "${c}Poetry installed, please ensure ~/.local/bin is in your PATH.${r}"
    fi
else
    echo -e "${c}Poetry is already installed.${r}"
    poetry --version
fi
