#!/usr/bin/env bash
source "$ROOT_DIR/programas/common/cargo_helper.sh"
install_cargo_crate "git-delta" "delta" || true
