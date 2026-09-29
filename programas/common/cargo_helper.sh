#!/bin/bash
c='\e[32m'
r='\e[0m'

# Helper function for cargo installation (prefers binstall)
install_cargo_crate() {
    local crate="$1"
    local bin_name="${2:-$crate}"
    if ! command -v "$bin_name" &> /dev/null; then
        printf "%b\n" "${c}Installing $crate...${r}"

        # Ensure cargo-binstall is installed if possible
        if ! command -v cargo-binstall &> /dev/null; then
             if command -v cargo &> /dev/null; then
                 printf "%b\n" "${c}Installing cargo-binstall...${r}"
                 cargo install cargo-binstall
             fi
        fi

        if command -v cargo-binstall &> /dev/null; then
            cargo binstall -y --force "$crate" || cargo install "$crate"
        else
            cargo install "$crate"
        fi
    else
        printf "%b\n" "${c}$crate (binary: $bin_name) already installed.${r}"
    fi
}

# Helper function for go installation
install_go_package() {
    local package="$1"
    local bin_name="${2:-$(basename "$package")}"

    if ! command -v "$bin_name" &> /dev/null; then
        printf "%b\n" "${c}Installing $bin_name (from $package)...${r}"
        if command -v go &> /dev/null; then
            go install "$package"
        else
            printf "%b\n" "${c}Go not found, skipping $bin_name installation.${r}"
        fi
    else
        printf "%b\n" "${c}$bin_name already installed.${r}"
    fi
}
