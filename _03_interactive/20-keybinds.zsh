#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zle/keybinds
# --------------------------------------------------------------------------- #

zmodload zsh/terminfo 2>/dev/null || true

function bindkey-zle() {
    local sequence=$1
    local widget=$2

    [[ -n "$sequence" ]] || return 0

    bindkey -M emacs "$sequence" "$widget"
    bindkey -M viins "$sequence" "$widget"
}

function keydebug() {
    emulate -L zsh

    local labels=("$@")
    local label
    local old_stty
    local bytes
    local ch
    local hex

    if (( $#labels == 0 )); then
        labels=(
            'shift+enter'
            'command+left'
            'command+right'
            'shift+command+left'
            'shift+command+right'
            'shift+home'
            'shift+end'
            'opt+delete'
            'command+delete'
        )
    fi

    print 'Press each requested combo once. Press q alone to stop.'

    for label in "${labels[@]}"; do
        print
        print "combo: $label"

        old_stty=$(stty -g) || return 1
        stty -echo -icanon

        bytes=''
        ch=''
        read -rsk 1 ch || {
            stty "$old_stty"
            return 1
        }
        bytes+="$ch"

        while read -rsk 1 -t 0.15 ch; do
            bytes+="$ch"
        done

        stty "$old_stty"

        hex=$(print -rn -- "$bytes" | xxd -p -c 32)

        [[ "$hex" == '71' ]] && break

        print "hex: ${hex:-<no-bytes>}"
    done
}

function zle-begin-selection() {
    (( REGION_ACTIVE )) || zle set-mark-command
}

function zle-clear-selection() {
    (( REGION_ACTIVE )) && zle deactivate-region
}

function zle-move-left() {
    zle-clear-selection
    zle backward-char
}

function zle-move-right() {
    zle-clear-selection
    zle forward-char
}

function zle-move-up() {
    zle-clear-selection
    zle up-line-or-history
}

function zle-move-down() {
    zle-clear-selection
    zle down-line-or-history
}

function zle-move-backward-word() {
    zle-clear-selection
    zle backward-word
}

function zle-move-forward-word() {
    zle-clear-selection
    zle forward-word
}

function zle-move-beginning-of-line() {
    zle-clear-selection
    zle beginning-of-line
}

function zle-move-end-of-line() {
    zle-clear-selection
    zle end-of-line
}

function zle-select-left() {
    zle-begin-selection
    zle backward-char
}

function zle-select-right() {
    zle-begin-selection
    zle forward-char
}

function zle-select-up() {
    zle-begin-selection
    zle up-line
}

function zle-select-down() {
    zle-begin-selection
    local cursor_before=$CURSOR
    zle down-line
    (( CURSOR == cursor_before )) && zle end-of-line
}

function zle-select-backward-word() {
    zle-begin-selection
    zle backward-word
}

function zle-select-forward-word() {
    zle-begin-selection
    zle forward-word
}

function zle-select-beginning-of-line() {
    zle-begin-selection
    zle beginning-of-line
}

function zle-select-end-of-line() {
    zle-begin-selection
    zle end-of-line
}

zle -N zle-move-left
zle -N zle-move-right
zle -N zle-move-up
zle -N zle-move-down
zle -N zle-move-backward-word
zle -N zle-move-forward-word
zle -N zle-move-beginning-of-line
zle -N zle-move-end-of-line
zle -N zle-select-left
zle -N zle-select-right
zle -N zle-select-up
zle -N zle-select-down
zle -N zle-select-backward-word
zle -N zle-select-forward-word
zle -N zle-select-beginning-of-line
zle -N zle-select-end-of-line

# Home/End vary by terminal, so bind both terminfo and common xterm/vt forms.
bindkey-zle "${terminfo[khome]:-}" zle-move-beginning-of-line
bindkey-zle "${terminfo[kend]:-}" zle-move-end-of-line
bindkey-zle $'\e[H' zle-move-beginning-of-line
bindkey-zle $'\e[F' zle-move-end-of-line
bindkey-zle $'\eOH' zle-move-beginning-of-line
bindkey-zle $'\eOF' zle-move-end-of-line
bindkey-zle $'\e[1~' zle-move-beginning-of-line
bindkey-zle $'\e[4~' zle-move-end-of-line

# Clear any active selection when moving without shift.
bindkey-zle "${terminfo[kcub1]:-}" zle-move-left
bindkey-zle "${terminfo[kcuf1]:-}" zle-move-right
bindkey-zle "${terminfo[kcuu1]:-}" zle-move-up
bindkey-zle "${terminfo[kcud1]:-}" zle-move-down
bindkey-zle $'\e[D' zle-move-left
bindkey-zle $'\e[C' zle-move-right
bindkey-zle $'\e[A' zle-move-up
bindkey-zle $'\e[B' zle-move-down
bindkey-zle $'\eb' zle-move-backward-word
bindkey-zle $'\ef' zle-move-forward-word
bindkey-zle $'\e[1;3D' zle-move-backward-word
bindkey-zle $'\e[1;3C' zle-move-forward-word
bindkey-zle $'\e[1;9D' zle-move-beginning-of-line
bindkey-zle $'\e[1;9C' zle-move-end-of-line
bindkey-zle $'\e[3~' delete-char-or-list
bindkey-zle $'\e[3;3~' kill-word
bindkey-zle $'\e[3;9~' kill-line

# Modified arrow keys are emitted by Ghostty as xterm-style CSI sequences.
bindkey-zle $'\e[1;2D' zle-select-left
bindkey-zle $'\e[1;2C' zle-select-right
bindkey-zle $'\e[1;2A' zle-select-up
bindkey-zle $'\e[1;2B' zle-select-down
bindkey-zle $'\e[1;2H' zle-select-beginning-of-line
bindkey-zle $'\e[1;2F' zle-select-end-of-line
bindkey-zle $'\e[1;4D' zle-select-backward-word
bindkey-zle $'\e[1;4C' zle-select-forward-word
bindkey-zle $'\e[1;10D' zle-select-beginning-of-line
bindkey-zle $'\e[1;10C' zle-select-end-of-line
bindkey-zle $'\e\r' self-insert-unmeta
