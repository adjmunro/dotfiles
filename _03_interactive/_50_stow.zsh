#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that GNU Stow is installed
installed stow || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

# Restow files all from DOTFILES to HOME.
# .                 stow everything, recursively, in the source dir (unless ignored)
# --dir=            source directory
# --target          target directory
# --dotfiles        map `dot-zshrc` to `.zshrc` etc.
# --no-folding      symlink only leaf-nodes (files, not directories) & create intermediates
# --restow          unstow existing symlinks, then stow it again anew
a restow="stow . --dir=$DOTFILES --target=$HOME --dotfiles --no-folding --restow"
a nostow="restow --simulate --verbose=1"
a unstow="stow --dir=$DOTFILES --target=$HOME --dotfiles --delete ."
