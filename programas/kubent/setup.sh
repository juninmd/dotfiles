#!/usr/bin/env bash
c='\e[32m'
r='\e[0m'
if ! command -v kubent &> /dev/null; then
    echo -e "${c}Installing kubent...${r}"
    sh -c "$(curl -sSL https://git.io/install-kubent)"
    # Move from default install location to ~/.local/bin or just leave it if install script puts it in /usr/local/bin
    if [ -f "/usr/local/bin/kubent" ] && [ ! -x "$HOME/.local/bin/kubent" ]; then
        mkdir -p "$HOME/.local/bin"
        sudo cp /usr/local/bin/kubent "$HOME/.local/bin/kubent"
        sudo chown "$USER:$USER" "$HOME/.local/bin/kubent"
    fi
else
    echo -e "${c}kubent is already installed.${r}"
fi
