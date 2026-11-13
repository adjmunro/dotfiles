#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that yazi is installed.
installed yazi || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

# Override default "file system browser" with yazi.
export FILE_BROWSER='yazi'

# Enable changing the current working directory while using yazi.
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}
