#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   claude/alias   
# --------------------------------------------------------------------------- #

# Check that [name] is installed
#whence names &>/dev/null || return false 

# ------------------------------
#   Symlink Management
# ------------------------------
# Check all AGENTS.md files exist
alias ls-agents='find . -name "AGENTS.md" -type f'

# Verify symlinks are created
alias ls-claude='find . -name "CLAUDE.md" -type l'

# Check symlinks point to correct files
alias ls-claude-links='find . -name "CLAUDE.md" -type l -exec ls -la {} \;'

# Verify content is agent-agnostic
alias check-claude='grep -r "Claude Code (claude.ai/code)" . --include="*.md" | grep AGENTS.md'

# Check for broken symlinks
alias ls-claude-broken='find . -name "CLAUDE.md" -type l ! -exec test -e {} \; -print'

# ------------------------------
#   Ouroboros
# ------------------------------
# Run claude with --dangerously-skip-permissions under caffeinate.
# Additional flags are passed through to claude (e.g. --worktree name).
ouroboros() {
  caffeinate -i claude --dangerously-skip-permissions "$@"
}

# Remove all CLAUDE.md symlinks
alias rm-claude='find . -name "CLAUDE.md" -type l -delete'
