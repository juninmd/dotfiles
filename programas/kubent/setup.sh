#!/bin/bash
c='\e[32m'
r='\e[0m'
if ! command -v kubent &> /dev/null; then
    echo -e "${c}Installing kubent...${r}"
    curl -sSL https://git.io/install-kubent | bash
    # Move from default install location to ~/.local/bin or just leave it if install script puts it in /usr/local/bin
    if [ -f "/usr/local/bin/kubent" ] && [ ! -x "$HOME/.local/bin/kubent" ]; then
        mkdir -p "$HOME/.local/bin"
        sudo cp /usr/local/bin/kubent "$HOME/.local/bin/kubent"
        sudo chown "$(id -un):$(id -gn)" "$HOME/.local/bin/kubent"
    fi
else
    echo -e "${c}kubent is already installed.${r}"
fi
