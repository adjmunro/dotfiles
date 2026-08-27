#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that Git is installed
installed git || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

local alternatesDirectory="$HOME/.config/git/alternates"

function git-alt-create() {
    debug "Inside git repository: $(gitInsideRepo)\n"
    if [[ $gitInsideRepo == false ]]; then
        error "FATAL: Could not find git repository in $(pwd)\n"
        return 1
    fi

    local branch=${1:-$(gitBranchName)}
    local fork="$alternatesDirectory/${branch:t}"
    local source=$(gitRepoRoot)

    # Prevent overwriting existing alternates.
    if [[ -d "$fork" ]]; then
        error "FATAL: An alternate workspace for branch '${branch:t}' already exists at $fork\n"
        return 1
    fi

    # Create and initialize new repository & object
    info "Initialising new git alternate at $fork\n"
    mkdir -p "$fork/.git/objects/info" && git -C $fork init --initial-branch=suppress

    # Set up object sharing (use absolute path)
    # Backlink source directory to object store
    info "Backlinking git alternate objects to main workspace...\n"
    echo "$source/.git/objects" > "$fork/.git/objects/info/alternates"

    # Copy git config (inherits remotes)
    info "Inheriting remotes from main workspace...\n"
    cp "$source/.git/config" "$fork/.git/config"

    # Add parent remote and fetch
    info "Fetching parent...\n"
    git -C $fork remote add parent $source
    git -C $fork fetch parent

    local alternates=$(git -C $source remote -v | grep $alternatesDirectory | awk '{print $2}' | sort --unique)
    info "Alternates: $alternates\n"
    for peer in $alternates; do
        debug "$peer found\n"
        if [[ -d $peer ]]; then
            debug "$peer exists\n"
        fi
    done

    # Backlink main workspace to alternate
    info "Adding alternate remote to main workspace...\n"
    # git -C $source remote add ${branch:t} $fork

    # Checkout branch (track from parent)
    info "Checkout alternate branch ${branch:t}\n"
    git -C $fork checkout $branch
    cd $fork
}

function git-alt-list() {
    local arrayRef=$1
    local alternatesDirectory="$HOME/.config/git/alternates"
    # local -a alternates=$(git remote -v | grep $alternatesDirectory | awk '{print $2}' | sort --unique)
    set -A "$arrayRef" $(git remote -v | grep $alternatesDirectory | awk '{print $2}' | sort --unique) #${alternates[@]}
}

function menu() {
    local prompt=$1; shift # Pop first arg as prompt
    local choices=("$@") # Everything else are options
    printf "%s\n" "${choices[@]}" | fzf --height=10% --reverse
}

function git-alt-remove() {
    debug "Inside git repository: $(gitInsideRepo)\n"
    if [[ $gitInsideRepo == false ]]; then
        error "FATAL: Could not find git repository in $(pwd)\n"
        return 1
    fi

    local -a choices=()
    local selection=$(menu "Choose alternate to delete:" "${$(git-alt-list $choices)}")
    if [ -z $selection ]; then
        error "User did not select an option.\n"
        return 1;
    else
        info "Selected $selection\n"
    fi

    # -f/--force to delete even unstaged files or unpushed branches; otherwise fail on unsafe deletion
    # $1 (no '-' prefix) exists -> delete $1
    # If inside an alternate -> delete alternate
    # If inside main repo
    local repo=$(gitRepoRoot)
    if [[ ${repo:h:t} == "alternates" ]]; then
        info "Deleting $repo!\n"

        info "rm -rfd $repo\n"
    fi

    info "${$(gitRepoRoot):h:t}\n"
}
