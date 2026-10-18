#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   ghostrealm/alias
# --------------------------------------------------------------------------- #

# Build and run ghostrealm in release mode from anywhere, detached in the background.
# Output goes to a log (overwritten each run); the cd happens in a subshell so the
# caller's directory is untouched.
function realm() {
    local dir="$HOME/Developer/ghostrealm"
    local log="$HOME/Library/Logs/ghostrealm.log"
    [[ -d $dir ]] || { print -u2 "realm: $dir not found"; return 1 }
    (
        cd -- "$dir" || exit 1
        cargo run --release -- "$@" </dev/null >"$log" 2>&1 &
    )
    print "realm: running in background, logs: $log"
}
