#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   homebrew/alias   
# --------------------------------------------------------------------------- #

# Check that homebrew is installed
whence brew &>/dev/null || return false 


function summon() {
  if [[ -z "$1" ]]; then
    echo "Usage: summon <package>"
    return 1
  fi

  local pkg="$1"

  brew info "$pkg" || return 1

  echo
  read "?Install $pkg? [y/N] " reply

  if [[ "$reply" =~ ^[Yy]$ ]]; then
    brew install "$pkg"
  else
    echo "Aborted."
  fi
}

