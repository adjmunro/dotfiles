#!/usr/bin/env zsh
# Sets the Ghostty (or any OSC-compatible terminal) window/tab title
# to reflect the current Claude session context.
#
# Called from SessionStart and UserPromptSubmit hooks.
# Writes OSC 0 escape sequence to /dev/tty (not stdout, which is JSON).

input=$(</dev/stdin)
cwd=$(echo "$input" | jq -r '.cwd // ""')
event=$(echo "$input" | jq -r '.hook_event_name // ""')

[[ -n "$cwd" ]] && cd "$cwd" 2>/dev/null

set_title() {
  printf '\033]0;%s\007' "$1" > /dev/tty
}

# Derive a short repo name from the remote URL (handles HTTPS and SSH remotes)
repo=$(git remote get-url origin 2>/dev/null | sed 's/.*[/:]\([^/:]*\)\.git$/\1/; s/.*[/:]\([^/:]*\)$/\1/')
branch=$(git branch --show-current 2>/dev/null)

if [[ -z "$repo" ]]; then
  # Not a git repo — use the directory name
  set_title "$(basename "$cwd")"
  echo "{}"
  exit 0
fi

# On SessionStart, check for an open PR (gh is too slow for every prompt submit)
if [[ "$event" == "SessionStart" ]]; then
  pr_json=$(timeout 3 gh pr view --json number,title 2>/dev/null)
  if [[ -n "$pr_json" ]]; then
    pr_num=$(echo "$pr_json" | jq -r '.number')
    pr_title=$(echo "$pr_json" | jq -r '.title' | cut -c1-40 | sed 's/ *$//')
    set_title "$repo · PR #$pr_num · $pr_title"
    echo "{}"
    exit 0
  fi
fi

if [[ -z "$branch" || "$branch" == "main" || "$branch" == "master" || "$branch" == "develop" ]]; then
  set_title "$repo"
else
  # Humanise branch name:
  # Strip leading ticket prefix: "03-11-", "PROJ-123-", etc.
  # Strip conventional type prefix: feat/, fix/, refactor/, chore/, etc.
  # Replace separators with spaces and truncate.
  short=$(echo "$branch" \
    | sed 's/^[0-9][0-9]-[0-9][0-9]-//' \
    | sed 's/^[A-Z][A-Z]*-[0-9][0-9]*-//' \
    | tr '/_-' '   ' \
    | tr -s ' ' \
    | sed -E 's/^ *(feat|fix|refactor|chore|docs|test|build) //' \
    | cut -c1-28 \
    | sed 's/ *$//')
  set_title "$repo · $short"
fi

echo "{}"
exit 0
