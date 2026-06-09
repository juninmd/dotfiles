#!/bin/sh
echo -e "\e[32mInstalling devenv...\e[0m"
if command -v nix > /dev/null 2>&1; then
  nix profile install --accept-flake-config github:cachix/devenv/latest
else
  echo "Nix not found. Devenv requires Nix to be installed."
fi
