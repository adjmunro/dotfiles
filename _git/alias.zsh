#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   git/alias   
# --------------------------------------------------------------------------- #

# Check that Git is installed
whence git &>/dev/null || return false

function gitignore() {
    (( $# == 0 )) && return false
    mkdir -p /tmp/gitignore

    for f in "$@"; do
        echo "Moving $f to /tmp/gitignore"
        mv $f /tmp/gitignore/$f
    done

    git commit . -m "Ignored $@"
    echo "Restoring $f to git repository"
    mv /tmp/gitignore/* .
    rmdir /tmp/gitignore
}

# List files affected by gitignore changes (i.e. already indexed)
alias list-gitignore="git ls-files --cached --ignored --exclude-standard"

# Untrack a file already indexed by git
alias git-untrack-file="git rm -r --cached"

# Untrack ignored files
alias untrack-gitignore="list-gitignore | sed 's/.*/\"&\"/' | xargs $(git-untrack-file)"

# Delete merged branches? TODO(verify!)
alias rm-merged='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'

abbr s="git status"
abbr co="git checkout"
abbr br="git branch"
abbr cm="git commit -m"
abbr lg="git log --oneline --graph --decorate --all"
