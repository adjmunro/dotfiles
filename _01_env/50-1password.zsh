#!/usr/bin/env zsh

# 1Password's SSH agent socket lives at ~/.1password/agent.sock on Linux. Link
# the same path on macOS so ~/.ssh/config can name one path on both platforms.
if macos && [[ ! -e ~/.1password/agent.sock ]]; then
    () {
        local socket=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
        [[ -S $socket ]] || return 0
        mkdir -p -m 700 ~/.1password
        ln -sf "$socket" ~/.1password/agent.sock
    }
fi

# ssh itself reads IdentityAgent from ~/.ssh/config; this is for ssh-add and
# other tools that only look at $SSH_AUTH_SOCK.
if [[ -S ~/.1password/agent.sock ]]; then
    export SSH_AUTH_SOCK=~/.1password/agent.sock
fi
