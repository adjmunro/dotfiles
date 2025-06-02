# Add to PATH
fish_add_path -g "/opt/homebrew/bin"
fish_add_path -g "$HOME/.cargo/bin"

if status is-interactive
    # Commands to run in interactive sessions can go here
	
	# Aliases (Should come before init!)
	alias fish-config "vim ~/.config/fish/config.fish"
	alias fish-source "source ~/.config/fish/config.fish"
	alias vimrc "vim ~/.vimrc"
	alias ideavimrc "vim ~/.ideavimrc"
	alias rtx-config "vim ~/.tool-versions"
	alias py "/opt/homebrew/bin/python3"
	alias z "zoxide"

	# Initialisations
	thefuck --alias | source
	starship init fish | source
	zoxide init fish | source

end # fi is-interactive


