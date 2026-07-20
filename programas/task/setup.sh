#!/bin/bash
source "$(dirname "$0")/../common/cargo_helper.sh"
install_go_package "github.com/go-task/task/v3/cmd/task@latest" "task"
