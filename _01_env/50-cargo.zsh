#!/usr/bin/env zsh

# Check that rustup is installed. Test the env file, not `installed cargo`:
# cargo is only on PATH *after* this file runs.
[[ -f "$HOME/.cargo/env" ]] || return $SKIP_DOTFILE

# Put ~/.cargo/bin (rustup's cargo, rustc, clippy, rustfmt…) on PATH.
prepath "$HOME/.cargo/bin"
