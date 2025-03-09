# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Pull the latest formulas
brew update

# Install initial dotfiles requirements
brew install git stow ghostty

# Clone dotfiles repository
git clone git@github.com:adjmunro/dotfiles.git ~/Developer/dotfiles

# Use GNU Stow to symlink the repository into your home directory
cd ~/Developer/Dotfiles; stow . --target=$HOME --dotfiles -nv2
