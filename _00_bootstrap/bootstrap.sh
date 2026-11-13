source ../_libs/logger.zsh

# Define the repository destination.
if macos; then
    export DOTFILES=${DOTFILES:-"~/Developer/dotfiles"}
else if linux; then
    export DOTFILES=${DOTFILES:-"~/dotfiles"}
else;
    error "Unexpected OS $OSTYPE!\n"
    return false
fi

# TODO: Split by package manager

# Remote Homebrew installation script.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Ensure the homebrew database is up-to-date.
brew upgrade

# Install the minimum dependencies.
brew install git stow zsh

# Clone the repository.
~/mkdir -p $DOTFILES
git clone git@github.com:adjmunro/dotfiles.git $DOTFILES

# Use Stow to symlink the repository to your home directory.
cd $DOTFILES
stow . --dir=$DOTFILES --target=$HOME --dotfiles --no-folding --verbose=2

# Set the machine name and logging level.
cp -i $DOTFILES/_machine.zsh $DOTFILES/_local.zsh
vim $DOTFILES/_local.zsh
