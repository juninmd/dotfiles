#!/bin/bash
c='\e[32m'
r='\e[0m'
# Yq (YAML Processor)
if ! command -v yq &> /dev/null; then
    echo -e "${c}Installing yq...${r}"
    if command -v go &> /dev/null; then
        go install github.com/mikefarah/yq/v4@latest
    else
        echo -e "${c}Go not found. Using curl fallback for yq...${r}" # NOSONAR
        # Fallback to binary download if go is missing (unlikely as it is installed above)
        sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 # NOSONAR
        sudo chmod +x /usr/local/bin/yq
    fi
else
    echo -e "${c}yq already installed.${r}"
fi
