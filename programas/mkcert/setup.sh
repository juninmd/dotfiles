#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Mkcert (Local CA for valid HTTPS certs)
install_go_package filippo.io/mkcert@latest mkcert
