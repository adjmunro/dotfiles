#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   rustup/update   
# --------------------------------------------------------------------------- #

# Check that Rustup is installed
which rustup &>/dev/null || return false
echo"Update Rust Toolchain"

# Update Rust Toolchain
rustup toolchain install stable

