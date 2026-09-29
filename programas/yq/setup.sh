#!/bin/bash
c='\e[32m'
r='\e[0m'
# Yq (YAML Processor)
if ! command -v yq &> /dev/null; then
    printf "%b\n" "${c}Installing yq...${r}"
    if command -v go &> /dev/null; then
        go install github.com/mikefarah/yq/v4@latest
    else
        printf "%b\n" "${c}Go not found. Using curl fallback for yq...${r}"
        # Fallback to binary download if go is missing (unlikely as it is installed above)
        sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
        sudo chmod +x /usr/local/bin/yq
    fi
else
    printf "%b\n" "${c}yq already installed.${r}"
fi
