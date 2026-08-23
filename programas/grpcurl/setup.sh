#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../common/cargo_helper.sh"
# Grpcurl (cURL for gRPC)
install_go_package github.com/fullstorydev/grpcurl/cmd/grpcurl@latest grpcurl
