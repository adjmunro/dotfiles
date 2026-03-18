# Global Claude Code Instructions

## Tool Usage

**File reading**: Always use the `Read` tool instead of `cat`, `head`, `tail`, or `sed` via Bash. For files over ~500 lines, use `offset` and `limit` to read in pages rather than loading the whole file.
**File search**: Always use `Glob` instead of `find` or `ls`.
**Content search**: Always use `Grep` instead of `grep` or `rg`.
**File editing**: Always use `Edit` instead of `sed` or `awk`.
**File creation**: Always use `Write` instead of `echo >` or heredoc redirection.
**Web fetching**: Always use `WebFetch` instead of `curl` or `wget`.

Reserve `Bash` exclusively for system commands that have no dedicated tool equivalent (e.g. git, package managers, build tools). A PreToolUse hook enforces this — attempting to use `cat`, `grep`, `rg`, `find`, or `ls` standalone via Bash will be blocked.

## Shell

The environment uses **zsh** as the default shell. Always write commands using zsh syntax — aliases and functions from `.zshrc`/`.zshenv` are available (e.g. `restow`, `gt`). Do not default to bash-isms or add `#!/bin/bash` shebangs to inline scripts.

## Agent Tool

Prefer the `Agent` tool as the default for tasks that involve exploration or independent subtasks. Use it when:
- Exploring an unfamiliar codebase area (likely more than 2–3 files)
- Research requiring multiple search rounds (protect main context from noise)
- Two or more independent tasks that can run in parallel (launch multiple agents concurrently)
- Work that would flood the main context window with large output

Do **not** use Agent for: single targeted reads, quick Grep/Glob lookups, or tasks requiring the current conversation context.

## Plugins & MCP Servers

Plugins and MCP servers are **disabled by default** unless explicitly enabled by a project. Do not assume their tools are available unless a project's CLAUDE.md or settings confirm they are active. Suggesting enabling a plugin or MCP server is fine if it's clearly relevant to the project, but enabling should always be scoped to the local project — never globally.

Exceptions that are always available globally:
- `superpowers` — skills and workflow tooling
- `code-review` — PR review commands

All other plugins (kotlin-lsp, firebase, figma, etc.) and MCP servers must be opted into per-project. This keeps session token overhead low and avoids injecting tool schemas that won't be used.

## Custom CLI Tools

When a project documents custom CLI tools, prefer them over manual Bash commands. Each tool should be listed with:
- The command name and what it does
- The trigger condition (when to use it instead of doing things manually)

This is the primary discovery mechanism — if a tool isn't documented here or in a project CLAUDE.md, it won't be used reliably. MCP servers are an alternative for tools that need automatic discovery via schema injection, but carry per-session token overhead from schema loading.
