#!/bin/bash
c='\e[32m' # Green Color
r='\e[0m' # Reset Color

printf "%b\n" "${c}Installing lazynpm (NPM TUI)...${r}"

if ! command -v lazynpm &> /dev/null; then
    if command -v go &> /dev/null; then
        go install github.com/jesseduffield/lazynpm@latest
        printf "%b\n" "${c}lazynpm installed successfully via go.${r}"
    else
        printf "%b\n" "${c}Go not found. Unable to install lazynpm.${r}"
    fi
else
    printf "%b\n" "${c}lazynpm is already installed.${r}"
fi
