#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

echo -e "${c}Installing lazynpm (NPM TUI)...${r}"

if ! command -v lazynpm &> /dev/null; then
    if command -v go &> /dev/null; then
        go install github.com/jesseduffield/lazynpm@latest
        echo -e "${c}lazynpm installed successfully via go.${r}"
    else
        echo -e "${c}Go not found. Unable to install lazynpm.${r}"
    fi
else
    echo -e "${c}lazynpm is already installed.${r}"
fi
