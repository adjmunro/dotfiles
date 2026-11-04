# Git Hooks & Gitconfig Split — Design Spec
**Date:** 2026-03-25
**Status:** Approved

---

## Overview

Add global git hooks (sensitive data scanner, commit signing) to dotfiles, and split `~/.gitconfig` into a shareable dotfiles-tracked file and a local private file. Also add two editor aliases for quick access to both config files.

---

## Infrastructure

### Gitconfig Split

`~/.gitconfig` is currently a real file (not symlinked) containing both shareable settings and private user identity. It will be split:

| File | Location | In Dotfiles | Contents |
|---|---|---|---|
| `dot-gitconfig` | `~/.gitconfig` (symlinked) | Yes | Shareable config + `[include]` pointing to local |
| `.gitconfig.local` | `~/.gitconfig.local` | No | `[user]` name, email, signingkey |

The `[include]` directive at the bottom of `dot-gitconfig`:
```ini
[include]
    path = ~/.gitconfig.local
```

Values in `.gitconfig.local` override dotfiles ones where they clash, allowing per-machine overrides.

**Shareable config includes:** `[gpg]` format, `[gpg "ssh"]` op-ssh-sign path, `[commit] gpgsign = false`, `[url]` insteadOf, `[credential]` gh helpers, `[core] hooksPath`.

**Local config includes:** `[user]` name, email, signingkey only. Must NOT include `gpgsign = true` — signing is delegated to the pre-push hook, and re-enabling it locally would conflict with that strategy.

### Hooks Directory

- Hooks live at `dot-config/git/hooks/` in dotfiles
- Symlinked to `~/.config/git/hooks/` via `restow`
- `~/.gitconfig` (via `dot-gitconfig`) sets `core.hooksPath = ~/.config/git/hooks`
- Both hook files must be executable (`chmod +x`)
- Both hook files use `#!/usr/bin/env zsh` as their shebang

### Gitconfig Settings

Added to `dot-gitconfig`:
- `commit.gpgsign = false` — signing is delegated to the pre-push hook
- `core.hooksPath = ~/.config/git/hooks`

---

## `_git/alias.zsh` — New Aliases

Two aliases added to `_git/alias.zsh` following the existing `.aerospace` pattern:

```zsh
a .gitconfig="$EDITOR $DOTFILES/dot-gitconfig"
a .gitlocal="$EDITOR ~/.gitconfig.local"
```

`.gitconfig` opens the dotfiles-tracked shareable config. `.gitlocal` opens the private local config. Dot-prefixed alias names are valid in zsh and consistent with the `.aerospace` alias already present in this codebase.

---

## `pre-commit` — Sensitive Data Scanner

**Trigger:** Every `git commit`
**Shebang:** `#!/usr/bin/env zsh`
**On match:** Blocks commit, prints offending lines
**Bypass:** `git commit --no-verify`

### Scan Target

Staged diff only — output of `git diff --cached --unified=0`. Lines beginning with `+` (additions/modifications) are checked; lines beginning with `---`/`+++` (file headers) are excluded. Lock files and generated files excluded from the diff: `*.lock`, `package-lock.json`, `Podfile.lock`, `*.resolved`.

### Patterns

All patterns are OR'd — any single match blocks the commit. Evaluated independently (order does not affect outcome).

| Category | Pattern notes |
|---|---|
| PEM private keys | `-----BEGIN [A-Z ]+ PRIVATE KEY-----` |
| NZ mobile | `02[1-9]` prefix, 10 digits total, optional spaces/hyphens as separators |
| NZ 0800/0900 | `0[89]00` prefix, then 6 digits with optional separators |
| NZ international mobile | `\+64 2[1-9]` prefix, 9 digits total after `+64`, optional spaces/hyphens as separators (e.g. `+64 21 xxx xxxx`) |
| Email addresses | Standard RFC email regex, **excluding** `@users.noreply.github.com` |
| Street addresses | Heuristic: integer followed by a capitalised street-type keyword (St, Rd, Ave, Lane, Dr, Pl, Cres, Tce, Way). False positives are possible (e.g. variable names); `--no-verify` is the intended escape hatch. |


### Output Format

```
  SENSITIVE DATA DETECTED in staged changes:

  + email: adam@example.com
  + address: 12 Example Street

  To bypass: git commit --no-verify
```

---

## `pre-push` — Signing + Sensitive Re-scan

**Trigger:** Every `git push`
**Shebang:** `#!/usr/bin/env zsh`

Git passes push information to the hook on stdin, one line per ref being pushed, in the format:
```
<local_ref> <local_sha> <remote_ref> <remote_sha>
```
Where `remote_sha` is all zeros for a new (not yet pushed) branch.

### Phase 1 — Sensitive Data Re-scan (blocks)

Re-runs the same pattern scan across all commits in the push range. For each commit SHA in the range, diff is produced via `git show --unified=0 <sha>` and scanned using the same patterns as pre-commit. Blocks the push if any match is found, with the same output format as pre-commit:

```
  SENSITIVE DATA DETECTED in pushed commits:

  + email: adam@example.com

  To bypass: git push --no-verify
```

Range for Phase 1 is the same range used for Phase 2 (see below). If `remote_sha` is zeros (new branch), the range is from the merge-base with the local parent branch to `local_sha`. If parent branch detection fails for a new branch, Phase 1 mirrors Phase 2 behaviour: skip the scan with a warning and allow the push to proceed.

### Phase 2 — Unsigned Commit Signing (warn-only)

#### Range Detection

For each ref being pushed:

- **Existing remote branch** (`remote_sha` ≠ zeros): range is `remote_sha..local_sha` — unpushed commits only
- **New branch** (`remote_sha` = zeros): find parent branch locally via `git show-branch` output parsing; use `git merge-base <local_sha> <parent_branch>` as the base. If parent branch detection fails (orphan branch, ambiguous output, no common ancestor), skip signing for that ref with a warning.

Since only unpushed commits are ever rebased, the push is always a fast-forward. No force push is ever required or expected.

#### Base Tightening

Walk the range oldest-first using `git log --reverse --format="%H|%aE|%G?" <base>..<local_sha>`. For each commit authored by `$(git config user.email)` where `%G?` ≠ `N` (already signed), advance the base to that commit hash.

If signed and unsigned commits are interleaved (e.g., signed at position 3, unsigned at position 2), advancing the base past the most recent signed commit will skip any unsigned commits before it. This is intentional — commits already pushed and signed are not re-examined, and partial signing within an already-pushed range is considered out of scope.

At the end of this walk, the base is the most recent already-signed commit by the user (or the original `remote_sha`/merge-base if none were signed).

#### Signing via Claude Agent

1. Collect unsigned commits in the tightened range: commits where `%aE = $(git config user.email)` and `%G? = N`
2. If none found: exit 0 cleanly
3. If found: record `HEAD_BEFORE=$(git rev-parse HEAD)`, then launch:

```zsh
claude --dangerously-skip-permissions -p "<prompt string as positional argument>"
```

The prompt (single positional string argument) instructs claude to:
- Get the parent of the oldest unsigned commit: `git rev-parse <oldest_hash>^`
- Run the rebase: `git rebase --exec 'if [ "$(git log -1 --format=%aE)" = "<author_email>" ]; then git commit --amend --no-edit -S; fi' <parent>`
- Output only: `OK` on success, `FAILED: <reason>` on failure

4. After claude returns, check `HEAD_AFTER=$(git rev-parse HEAD)`:
   - `HEAD_BEFORE ≠ HEAD_AFTER` → print "commits signed — please push again", exit 1
   - `HEAD_BEFORE = HEAD_AFTER` and claude output contained `FAILED` → print warning, exit 0
   - `HEAD_BEFORE = HEAD_AFTER` and no failure → exit 0 (nothing was signed, push proceeds)

If the signing process fails at any point (claude exits non-zero, output contains `FAILED`, or an unexpected error occurs), print a warning and exit 0 — the push proceeds unsigned.

---

## Migration Steps (ordered)

1. Extract private values from `~/.gitconfig` into `~/.gitconfig.local` (name, email, signingkey). Ensure `gpgsign` is NOT in the local file.
2. Delete `~/.gitconfig` (must be done before restow, as stow will not overwrite a real file).
3. Create `dot-gitconfig` in dotfiles with shareable config + `[include]`.
4. Create `dot-config/git/hooks/pre-commit` and `pre-push`, make both executable.
5. Add aliases to `_git/alias.zsh`.
6. Run `restow` — creates `~/.gitconfig` symlink and `~/.config/git/hooks/` symlink.
7. Verify: `stat ~/.gitconfig` should show `lrwxr-xr-x`. `git config --list` should show both shared and local values merged.

---

## File Checklist

| File | Action |
|---|---|
| `dot-gitconfig` | Create — shareable gitconfig |
| `~/.gitconfig` | Delete (real file), then replaced by symlink via restow |
| `~/.gitconfig.local` | Create locally — private user identity (not committed) |
| `dot-config/git/hooks/pre-commit` | Create — sensitive data scanner, chmod +x |
| `dot-config/git/hooks/pre-push` | Create — signing + re-scan, chmod +x |
| `_git/alias.zsh` | Edit — add `.gitconfig` and `.gitlocal` aliases |

---

## Out of Scope

- Per-repo hook overrides
- Allowlisting specific patterns or files
- Validating signature cryptographic integrity (presence check only)
- AU/US phone number formats
- Signing commits that have already been pushed to remote
