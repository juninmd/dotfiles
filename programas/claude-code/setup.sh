#!/usr/bin/env bash

set -euo pipefail

# Print styled messages
print_info() {
    printf "%b\n" "\033[1;36m[Claude Code]\033[0m $1"
}

print_success() {
    printf "%b\n" "\033[1;32m[SUCCESS]\033[0m $1"
}

print_error() {
    printf "%b\n" "\033[1;31m[ERROR]\033[0m $1"
}

if ! command -v npm &> /dev/null; then
    print_error "npm is required to install Claude Code but was not found."
    exit 1
fi

if command -v claude &> /dev/null; then
    print_success "Claude Code is already installed."
    exit 0
fi

print_info "Installing Claude Code..."

if npm config get prefix | grep -q '/usr'; then
    sudo npm install -g @anthropic-ai/claude-code
else
    npm install -g @anthropic-ai/claude-code
fi

print_success "Claude Code installed successfully."
