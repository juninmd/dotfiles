#!/bin/bash
c='\e[32m'
r='\e[0m'
# Cpufetch (Simple yet fancy CPU architecture fetching tool)
if ! command -v cpufetch &> /dev/null; then
    echo -e "${c}Installing cpufetch...${r}"
    case "$(uname -m)" in
        x86_64) BIN_ARCH="x86_64" ;;
        aarch64) BIN_ARCH="arm64" ;;
        *) BIN_ARCH="x86_64" ;;
    esac
    curl -fsSL "https://github.com/Dr-Noob/cpufetch/releases/latest/download/cpufetch-linux-${BIN_ARCH}" -o /tmp/cpufetch
    sudo mv /tmp/cpufetch /usr/local/bin/cpufetch
    sudo chmod +x /usr/local/bin/cpufetch
else
    echo -e "${c}cpufetch already installed.${r}"
fi
