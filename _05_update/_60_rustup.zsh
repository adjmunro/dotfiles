#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that Rustup is installed
installed rustup || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

info "=== Update Rust Toolchain ===\n"

# Update Rust Toolchain
rustup toolchain install stable
