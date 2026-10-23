#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   reclaim/alias
# --------------------------------------------------------------------------- #

# Check that cargo is installed
installed cargo || return $SKIP_DOTFILE

# Build and run reclaim in release mode from anywhere, e.g. `reclaim` or `reclaim ~/Projects`.
# Unlike realm this stays in the foreground: reclaim is an interactive TUI that needs the
# terminal. --manifest-path (instead of a cd) keeps the caller's directory, so relative
# [dir...] arguments still resolve from where you are.
function reclaim() {
    local dir="$HOME/Developer/reclaim"
    [[ -d $dir ]] || { print -u2 "reclaim: $dir not found"; return 1 }
    cargo run --release --manifest-path "$dir/Cargo.toml" -- "$@"
}
