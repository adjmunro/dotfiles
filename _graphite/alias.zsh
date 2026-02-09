#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   graphite/alias
# --------------------------------------------------------------------------- #

# Check that Graphite CLI is installed
whence gt &>/dev/null || return false

# Branch helpers (uses trunk from _git/alias.zsh)
a restack="gt restack --branch $(trunk)"
a branches="gt log short --reverse --show-untracked"
a retrack="gt untrack; gt track"

# Sync workflow (only runs steps that exist)
function sync() {
    whence git &>/dev/null || return 1

    git fetch origin "$(trunk):$(trunk)"
    restack
    branches

    whence prune-dirs &>/dev/null && prune-dirs
}
