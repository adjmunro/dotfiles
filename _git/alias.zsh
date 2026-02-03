#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   git/alias   
# --------------------------------------------------------------------------- #

# Check that Git is installed
whence git &>/dev/null || return false

typeset -g TRUNK_BRANCH="${TRUNK_BRANCH:-main}"

function trunk() {
    local branch=""

    if git rev-parse --is-inside-work-tree &>/dev/null; then
        branch="$(git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null)"
        branch="${branch#origin/}"
        [[ -n "$branch" ]] && { echo "$branch"; return 0; }

        branch="$(git config --local --get trunk.branch 2>/dev/null || true)"
        [[ -n "$branch" ]] && { echo "$branch"; return 0; }

        branch="$(git config --local --get init.defaultBranch 2>/dev/null || true)"
        [[ -n "$branch" ]] && { echo "$branch"; return 0; }
    fi

    echo "${TRUNK_BRANCH}"
}

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
function untrack-gitignore() {
    list-gitignore | sed 's/.*/\"&\"/' | xargs git rm -r --cached --
}

# Delete merged branches? TODO(verify!)
alias rm-merged='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'

function fetch() {
    # No args: fetch trunk without checkout (origin trunk:trunk)
    if (( $# == 0 )); then
        local t
        t="$(trunk)"
        git fetch origin "${t}:${t}"
        return $?
    fi

    # If any flag is passed, defer to git fetch unchanged.
    local arg
    for arg in "$@"; do
        if [[ "$arg" == -* ]]; then
            git fetch "$@"
            return $?
        fi
    done

    # If a remote name is passed explicitly, defer to git fetch unchanged.
    if [[ "$1" == "origin" || "$1" == "upstream" ]]; then
        git fetch "$@"
        return $?
    fi

    # Otherwise, treat each arg as a branch name and fetch via refspec.
    for arg in "$@"; do
        if [[ "$arg" == *:* ]]; then
            git fetch origin "$arg"
        else
            git fetch origin "${arg}:${arg}"
        fi
    done
}

alias push-all="git push origin --all"

function gitstub() {
    [[ -z "$1" ]] && return 1
    mkdir -p "$1" && touch "$1/gitstub"
}

a s="git status"
a co="git checkout"
a br="git branch"
a cm="git commit -m"
a lg="git log --oneline --graph --decorate --all"
