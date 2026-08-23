#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# dotenv-linter (Linter for .env files)
install_cargo_crate dotenv-linter
