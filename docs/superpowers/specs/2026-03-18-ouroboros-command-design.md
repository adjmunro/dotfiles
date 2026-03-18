# Ouroboros Slash Command — Design Spec

**Date:** 2026-03-18
**Status:** Approved
**File to create:** `dot-claude/commands/ouroboros.md`

---

## Overview

`/ouroboros` is a slash command that autonomously manages a PR from current state to human-ready. The goal is to ship work that is genuinely ready for human review: all PR comments addressed, CI green, Copilot review clean, history rebased. It does not "fix" things by removing valid behaviour — if a comment is wrong, it defends the code with a source comment and a reply.

It is designed to run unattended (via the `ouroboros` shell function which wraps it in `caffeinate -i --dangerously-skip-permissions`). If invoked directly via `/ouroboros` without going through the shell function, the caffeinate protection is absent — this is a known limitation.

---

## Entry Point & Routing

**Frontmatter:**
```yaml
description: Autonomous PR review loop — fix comments, pass CI, ship
argument-hint: [PR-url]
allowed-tools: Bash, Read, Edit, Write, Glob, Grep, WebFetch
model: opus
```

Note: worktree operations are performed via `git worktree` through Bash rather than the `EnterWorktree`/`ExitWorktree` tools, because the loop needs to persist inside the worktree across multiple iterations.

**First action — resolve repo identity:**
```bash
gh repo view --json nameWithOwner --jq '.nameWithOwner'
# → "owner/repo" used in all subsequent gh api calls
```

**Routing on startup:**
- `$ARGUMENTS` is a GitHub PR URL → extract PR number, look up branch, set up worktree, enter review loop
- `$ARGUMENTS` is empty → run `gh pr view --json number,headRefName` on current branch:
  - PR exists → enter review loop (use current directory as-is, no worktree switch needed)
  - No PR → resolve base branch, generate draft PR, then enter review loop

---

## Worktree & Branch Setup

**Why:** Work happens in an isolated worktree so the main workspace is never disrupted and the correct branch HEAD is always present.

1. Extract PR branch name from `gh pr view --json headRefName`
2. Run `git worktree list --porcelain` — reuse existing worktree for that branch if one exists, otherwise `git worktree add <path> <branch>`
3. All edits, commits, and pushes happen inside that worktree
4. On no-arg + no-existing-PR path: use the current directory (branch already exists locally)

**Base branch resolution:**

**Why:** Never accidentally target `master`/`main` — that gate exists to prevent bypassing the review chain. Stacked PRs should chain through their parent branches so merging happens in the right order.

Procedure:
1. `git fetch origin` to ensure remote refs are current
2. Identify candidate parent branches by running `git log --oneline HEAD` and comparing against `git branch -r` — find the most recent remote branch that contains the fork point of the current branch
3. Use `git log <candidate>..HEAD --oneline` to confirm the candidate contains no commits that belong to HEAD (i.e. is a true ancestor)
4. Apply rules in order:
   - If candidate is `master` or `main` → substitute `develop` (never target master/main unless explicitly passed as `$ARGUMENTS`)
   - If candidate is `develop` → target `develop`
   - If candidate is any other branch AND that branch has an open PR → target the candidate branch itself as base (preserve stacked PR chain — target the direct parent, not the parent's PR's base)
   - If candidate is any other branch but has no open PR → walk up one level and repeat; if no parent with a PR is found, fall back to `develop`
5. Re-evaluate after every rebase: if the resolved base has changed, update the PR target via `gh pr edit --base <new-base>`

---

## PR Creation (no-arg, no existing PR)

**Why:** New work always starts as a draft to avoid notifying reviewers before it's ready. The description is generated from actual commits and diff so reviewers have context without the author writing it manually.

1. Resolve base branch (per above)
2. Generate PR title from branch name (humanised: hyphens → spaces, strip ticket prefix) + most recent commit subject
3. Generate PR description:
   - Commit summary: `git log <base>..HEAD --oneline`
   - Scope: `git diff <base>..HEAD --stat`
   - Synthesise into a concise "what changed and why" paragraph grounded in commit messages — do not fabricate motivation not present in the commits
4. Create as draft: `gh pr create --draft --base <resolved-base> --title "..." --body "..."`
5. Request Copilot as reviewer (see Copilot section)
6. Enter review loop

---

## Main Loop

**Why:** The loop removes the human from the iteration cycle. Each pass gathers all current feedback (human + Copilot), fixes or defends against it, keeps history rebased, then pushes once and verifies. A single push per iteration reduces noise in the PR timeline.

Runs until exit conditions are met. All changes are committed locally before any push.

```
SETUP: Resolve owner/repo, PR number, branch name. Keep these for the whole session.

ITERATION:

1. Fetch all open PR comments and review comments:
   - Top-level PR comments: GET /repos/{owner}/{repo}/issues/{number}/comments
     (reply via: POST /repos/{owner}/{repo}/issues/{number}/comments)
   - Inline review comments: GET /repos/{owner}/{repo}/pulls/{number}/comments
     (reply via: POST /repos/{owner}/{repo}/pulls/{number}/comments/{id}/replies)
   - Identify resolved comments: position == null (outdated diff position) OR
     the thread already has a reply from this session's bot identity

2. Triage human comments (skip already-resolved ones):
   - Valid → fix in code, commit with a message referencing the comment thread ID
   - Invalid/wrong → add an inline code comment in the relevant source file explaining
     why the existing behaviour is correct; commit; queue a PR reply with the same reasoning
     (queue = collect reply text + thread ID + endpoint type for posting in step 6)

3. Fetch most recent Copilot review comments:
   GET /repos/{owner}/{repo}/pulls/{number}/reviews → find entry where user.login == 'github-copilot[bot]' AND state != 'PENDING'
   GET /repos/{owner}/{repo}/pulls/{number}/reviews/{review_id}/comments
   Apply same triage as step 2; commit any fixes

   Criteria for "significant and valid" Copilot comment (treat these as actionable):
   - Points to a concrete bug, missing null-check, error path, or security issue
   - Identifies a real logic error or incorrect assumption
   - Flags a missing test case for a code path that exists
   Treat as noise / skip:
   - Style preferences already covered by the project's linter
   - Suggestions to add comments/docs where the code is already self-explanatory
   - Rewrites that don't change behaviour ("consider rewriting X as Y")
   - Repetition of a comment already addressed in this session

4. Check parent branch for new commits:
   git fetch origin <parent-branch>
   git log HEAD..origin/<parent-branch> --oneline
   If parent has new commits → git rebase origin/<parent-branch>
   On conflict:
     - Attempt to resolve only if the conflict is unambiguous (e.g. trivially non-overlapping changes)
     - If conflict requires judgment: git rebase --abort, print the conflicting files and a
       description of the conflict, halt the loop entirely (not a loop guard recurrence —
       this is a human decision point; do not retry)

5. Push once (all commits + rebase result):
   git push --force-with-lease origin <branch>
   Note: --force-with-lease is safe even on first push (no-op if already up to date)

6. Post queued PR comment replies:
   Use the correct endpoint per comment type (top-level vs inline review comment — see step 1)
   Replies are posted after push for chronological clarity; they are associated with thread IDs,
   not commits — no need to re-fetch thread IDs after the push

7. Request Copilot review and wait:
   Request: POST /repos/{owner}/{repo}/pulls/{number}/requested_reviewers
     body: {"reviewers": ["github-copilot[bot]"]}
   If Copilot is already a requested reviewer (409 or already present) → re-request by removing
   and re-adding: DELETE then POST
   Poll: GET /repos/{owner}/{repo}/pulls/{number}/reviews
     Find entry where user.login == 'github-copilot[bot]' AND state != 'PENDING'
   Poll interval: 15 seconds
   Timeout: 10 minutes — if Copilot review does not complete, log a warning, mark it as
   "timed out" in the final summary, and proceed (do not block indefinitely)
   If Copilot produces new significant/valid comments (per step 3 criteria) → loop back to step 2

8. Watch CI (CI run was triggered by the push in step 5 and has been running concurrently):
   Wait for run to appear: poll `gh run list --branch <branch> --limit 1 --json databaseId,status`
   until status != '' (retry up to 12× at 10-second intervals; if no run after 2 minutes, surface
   to user and halt)
   Watch: gh run watch <run-id> --exit-status
   (--exit-status causes gh run watch to exit non-zero when the run fails)
   On failure:
     a. Fetch failure details: gh run view <run-id> --log-failed
     b. If failure is in a test file → run that specific test locally first:
        identify the test command from CI config or the error output, run it, confirm it fails,
        then fix and confirm it passes locally before committing
     c. Fix the root cause, commit
     d. Loop back to step 4 (rebase → push → Copilot → CI)

9. Exit conditions (ALL must be true):
   - CI green (gh run view <run-id> --json conclusion shows conclusion == 'success')
   - Copilot review complete with no new significant/valid comments (or timed out — noted in summary)
   - All human comment threads resolved or replied to
   → Update PR description: regenerate using git log <base>..HEAD and git diff --stat,
     reflect any behaviour changes introduced during the loop
   → gh pr ready (mark non-draft)
   → Notification (see below)
   → Exit
```

**Loop guard:** Track a map of `{thread_id → fix_attempt_count}` and `{ci_check_name → fail_count}`. If the same thread ID or the same named CI check reaches 3 without being resolved, halt and surface to the user with a clear summary of what is stuck. Do not count rebase conflicts against the loop guard.

---

## Copilot Review Mechanism

**Why:** Copilot review is a pre-human gate — catch machine-detectable issues before a human spends time on the same things. The correct trigger is requesting Copilot as a GitHub reviewer (not posting a review comment as the bot user).

**Trigger:**
```bash
gh api repos/{owner}/{repo}/pulls/{number}/requested_reviewers \
  --method POST \
  --field 'reviewers[]=github-copilot[bot]'
```

**If Copilot is not enabled on the repo:** The API will return a 422 with an error about the reviewer. In this case: log "Copilot review not available on this repo — skipping", skip the Copilot gate entirely, and proceed to CI.

**Poll:**
```bash
gh api repos/{owner}/{repo}/pulls/{number}/reviews
# Find: user.login == 'github-copilot[bot]', state != 'PENDING'
# States: APPROVED, CHANGES_REQUESTED, COMMENTED, DISMISSED
```

Copilot must finish (or time out / be unavailable) before the PR is marked ready.

---

## Notification

**Why:** The user runs this unattended — macOS notification is the signal to come back. Terminal summary gives enough context to know what happened without opening the PR.

```bash
osascript -e 'display notification "PR #N ready for review" with title "Ouroboros" sound name "Glass"'
```

Terminal summary:
- PR number + URL
- Branch and base branch
- Comment counts: N human resolved, N Copilot resolved
- CI: green after N push(es)
- Copilot: completed / timed out / unavailable

---

## Error Handling Notes

- `gh api` transient failures (5xx, network): retry up to 3× with 5-second backoff before surfacing
- Rate limiting (403 with `X-RateLimit-Remaining: 0`): wait until `X-RateLimit-Reset` time, then retry
- `git push --force-with-lease` rejected (remote has diverged beyond our rebase): surface to user — do not force push blindly

---

## Permissions Required

New additions to `dot-claude/settings.json` (items already present are not listed):
- `Bash(gh api:*)`
- `Bash(gh run:*)`
- `Bash(osascript:*)`
- `Bash(git push:*)`
- `Bash(git rebase:*)`
- `Bash(gh copilot:*)` — in case gh copilot CLI is needed as a fallback

---

## Key Constraints (preserve these — they reflect deliberate decisions)

- **Never target `master`/`main` as base** unless explicitly passed — prevents bypassing the review chain
- **New PRs always created as drafts** — reviewers aren't notified until the work is verified
- **Push once per loop iteration** — batching commits + rebase reduces PR timeline noise
- **Copilot review must complete (or time out / be unavailable) before marking ready** — Copilot is a pre-human gate
- **CI and Copilot run concurrently** — CI starts on push; we poll Copilot while CI runs; no wasted wall time
- **Fail fast on CI** — `gh run watch --exit-status` exits on first failed job; don't wait for all checks
- **Don't remove valid behaviour to satisfy comments** — defend with source comments + PR replies; the code is the source of truth
- **Run failing tests locally before pushing a fix** — don't use CI as a debug loop
- **Loop guard at 3 recurrences of same thread ID or CI check name** — prevents infinite loops
- **Rebase conflicts are human decisions** — halt cleanly, do not attempt undirected resolution
