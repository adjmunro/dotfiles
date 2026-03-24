# Git Plan Storage: Orphan Branch vs Inline

**Goal:** Find the right home for implementation plans in a multi-worktree, multi-branch workflow — git-tracked, accessible from anywhere, no merge-to-develop required.

## The Problem

- Plans are often written before or during feature work
- Worktrees mean the plan might be created in a different location than where the work happens
- Want plans tracked in git, but not necessarily merged into `main`/`develop`
- Cross-branch access without duplication or sync headaches

## Option A: Orphan `plans` Branch + Dedicated Worktree

```zsh
git checkout --orphan plans
git rm -rf .
echo "# Plans" > README.md
git add README.md && git commit -m "init: plans branch"
git checkout -
git worktree add ../dotfiles-plans plans
```

**Workflow:**
1. Write plan → commit to `plans` branch via `../dotfiles-plans/`
2. Execute plan on feature branch — no plan files in feature branch
3. Mark done / archive → another commit to `plans`
4. Push `plans` branch independently to remote

**Naming convention:** plan files named after the branch (e.g. `02-09-fix_dotfiles.md`)

**Trade-offs:**
- ✓ Fully git-tracked, independent history
- ✓ Accessible from all worktrees at a fixed path
- ✓ Pushable without merging into develop
- ✗ Loses co-location of plan + code in git history
- ✗ Extra worktree to manage

## Option B: Inline on Feature Branch (`plans/` directory)

Plans committed directly to the feature branch alongside the code.

**Trade-offs:**
- ✓ Plan history co-located with code history
- ✓ Simple — no extra infrastructure
- ✗ Plans don't survive branch deletion
- ✗ Cross-branch access requires cherry-pick or separate checkout

## Decision Criteria

| Need | Best Option |
|------|-------------|
| Cross-branch / cross-worktree access | Orphan branch |
| Plan co-located with code history | Inline on feature branch |
| Plans outlive branches | Orphan branch |
| Simplicity | Inline on feature branch |

## Verdict

Use the **orphan branch** when plans are long-lived, cross-cutting, or need to be referenced across multiple worktrees. Use **inline** when the plan is short-lived and tightly scoped to a single branch's work.

A hybrid works too: short feature plans inline, larger cross-cutting plans on the orphan branch.
