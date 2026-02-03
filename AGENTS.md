# AGENTS.md

This repository is a personal dotfiles setup built around GNU Stow and modular Zsh config.
The goals are portability, clarity, and maintainability while learning Zsh.

## Conventions
- Descriptive comments are encouraged; clarity beats cleverness.
- Prefer modular files grouped by tool (one directory per tool).
- Each tool module should check if the tool exists before defining aliases/functions.
- Keep `dot-zshrc` minimal: only orchestrate `sources` order.
- Quote globs passed into `sources` so it can handle empty matches.
- Prefer functions when arguments are involved; use aliases/abbr for simple expansions.

## Stow
- `dot-*` paths are renamed by Stow into their dot-prefixed targets.
- `_*` prefixed directories and files are ignored by Stow (modules live here).

## Zsh Modules
- `*/init.zsh` is for tool initialization and should load before aliases.
- `*/alias.zsh` is for tool-specific aliases/abbr.
- `_zsh/*.zsh` is for core shell config (theme, editor, options, etc).
- `_session.zsh` runs last for shell startup behavior.

## zsh-abbr
- Load zsh-abbr in `_abbr/init.zsh` and guard it if the script isn't installed.
- When zsh-abbr is missing, fall back to standard aliases where possible.
