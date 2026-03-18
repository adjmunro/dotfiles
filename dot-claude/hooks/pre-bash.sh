#!/usr/bin/env zsh
# PreToolUse hook: redirect redundant Bash calls to dedicated Claude Code tools.
# Output must be valid JSON. Exit 2 = block the tool call.

input=$(</dev/stdin)
cmd=$(echo "$input" | jq -r '.tool_input.command // ""' | sed 's/^[[:space:]]*//')

block() {
  echo "{\"decision\": \"block\", \"reason\": \"$1\"}"
  exit 2
}

# Allow pipeline commands — dedicated tools don't support piping.
if echo "$cmd" | grep -q '|'; then
  echo "{}"
  exit 0
fi

tool=$(echo "$cmd" | awk '{print $1}')

# Redirect standalone file-reading commands → Read tool
if echo "$cmd" | grep -qE '^(cat|head|tail) '; then
  block "Use the Read tool instead of \`$tool\`. It provides structured output with line numbers and supports offset\/limit pagination for large files."
fi

# Redirect standalone search commands → Grep tool
if echo "$cmd" | grep -qE '^(grep|rg|egrep|fgrep) '; then
  block "Use the Grep tool instead of \`$tool\`. It provides structured results, output_mode control, and context lines."
fi

# Redirect standalone file discovery → Glob tool
if echo "$cmd" | grep -qE '^(find|fd) '; then
  block "Use the Glob tool instead of \`$tool\` for file discovery."
fi

# Redirect standalone directory listing → Glob tool
if echo "$cmd" | grep -qE '^ls( |$)'; then
  block "Use the Glob tool instead of \`ls\` for directory listing."
fi

echo "{}"
exit 0
