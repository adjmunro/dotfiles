#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   git/alias
# --------------------------------------------------------------------------- #

# Check that Git is installed
installed git || return $SKIP_DOTFILE

typeset -g TRUNK_BRANCH="${TRUNK_BRANCH:-main}"

# Open git configs in $EDITOR
a .gitconfig="$EDITOR $DOTFILES/dot-gitconfig"
a .gitlocal="$EDITOR $DOTFILES/.gitconfig.local"
a .gitignore="$EDITOR $DOTFILES/dot-config/git/ignore"

a s="git status"
a co="git checkout"
a br="git branch"
a cm="git commit -m"
a lg="git log --oneline --graph --decorate --all"
a push-all="git push origin --all"

# List files affected by gitignore changes (i.e. already indexed)
a list-gitignore="git ls-files --cached --ignored --exclude-standard"

# Untrack a file already indexed by git
a git-untrack-file="git rm -r --cached"

# Delete merged branches? TODO(verify!)
a rm-merged='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'

function gitInsideRepo() { git rev-parse --is-inside-work-tree }
function gitBranchName() { git rev-parse --abbrev-ref HEAD }
function gitRepoRoot() { git rev-parse --show-toplevel }

function trunk() {
    local branch=""

    if git rev-parse --is-inside-work-tree &>/dev/null; then
        branch="$(git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null)"
        branch="${branch#origin/}"
        [[ -n "$branch" ]] && { print  "$branch"; return 0; }

        branch="$(git config --local --get trunk.branch 2>/dev/null || true)"
        [[ -n "$branch" ]] && { print  "$branch"; return 0; }

        branch="$(git config --local --get init.defaultBranch 2>/dev/null || true)"
        [[ -n "$branch" ]] && { print  "$branch"; return 0; }
    fi

    print "${TRUNK_BRANCH}"
}

function gitignore() {
    (( $# == 0 )) && return false
    mkdir -p /tmp/gitignore

    for f in "$@"; do
        print "Moving $f to /tmp/gitignore"
        mv $f /tmp/gitignore/$f
    done

    git commit . -m "Ignored $@"
    print "Restoring $f to git repository"
    mv /tmp/gitignore/* .
    rmdir /tmp/gitignore
}

# Untrack ignored files
function untrack-gitignore() {
    list-gitignore | sed 's/.*/\"&\"/' | xargs git rm -r --cached --
}

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

function gitstub() {
    [[ -z "$1" ]] && return 1
    mkdir -p "$1" && touch "$1/gitstub"
}
