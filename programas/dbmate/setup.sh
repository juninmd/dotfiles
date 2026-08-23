#!/bin/bash
source "$(dirname "$0")/../common/cargo_helper.sh"
install_go_package "github.com/amacneil/dbmate/v2@latest" "dbmate"
