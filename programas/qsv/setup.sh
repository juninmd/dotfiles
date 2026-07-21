#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Qsv (High-performance CSV Data-Wrangling Toolkit)
install_cargo_crate qsv
