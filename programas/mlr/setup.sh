#!/bin/bash
c='\e[32m'
r='\e[0m'
echo -e "${c}Installing mlr...${r}"

# Source cargo helper to get install_go_package
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -f "$SCRIPT_DIR/../common/cargo_helper.sh" ]; then
    source "$SCRIPT_DIR/../common/cargo_helper.sh"
else
    echo -e "${c}Warning: cargo_helper.sh not found. Defining fallback function.${r}"
    install_go_package() {
        local package="$1"
        go install "$package"
    }
fi

install_go_package "github.com/johnkerl/miller/cmd/mlr@latest"
echo -e "${c}mlr installed.${r}"
