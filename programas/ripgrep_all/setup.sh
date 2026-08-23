#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# ripgrep_all (rga) - ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, etc.
install_cargo_crate ripgrep_all
