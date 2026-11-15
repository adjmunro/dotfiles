# SSH and Git Signing

Private keys live only in 1Password. Its SSH agent serves them, and Touch ID approves each use.

- `dot-ssh/*.pub`: public keys. `IdentityFile` points at these so ssh offers the right agent key per host (with `IdentitiesOnly yes`).
- `dot-ssh/config`: per-host routing. Every host uses the agent at `~/.1password/agent.sock`.
- `_01_env/50-1password.zsh`: on macOS, links `~/.1password/agent.sock` to the app's socket and exports `SSH_AUTH_SOCK`.
- `dot-gitconfig`: SSH commit signing via `op-ssh-sign`. Signing is off by default; sign a batch before pushing with `git rebase -f -S <base>`.
- `dot-config/git/adjmunro.gitconfig`: default email and signing key. `allowed_signers` lets git verify them.

## Adding a key

1. Create an SSH key item in 1Password. If it isn't in the Personal/Private vault, add the vault to `~/.config/1Password/ssh/agent.toml`.
2. Add an `ssh://user@host` URL to the item (a 1Password SSH bookmark).
3. Save the public key as `dot-ssh/<name>.pub`, then add a `Host` block with `IdentityFile ~/.ssh/<name>.pub` and `IdentitiesOnly yes`.
4. For a server, append the public key to its `~/.ssh/authorized_keys` *before* removing the old key, and test the new one first.

## Work identity

Git identity and the GitHub account used for SSH are separate. Both need routing. `dot-gitconfig` includes `dot-config/git/alphero.gitconfig` for `github.com/alpheroltd/**` remotes. It sets:

- `user.email`: the `adjmunro-alphero` noreply address.
- `user.signingkey`: the work signing key, also listed in `allowed_signers`.
- `core.sshCommand = ssh -i ~/.ssh/alphero.pub`: the work authentication key (`dot-ssh/alphero.pub`).

The work account uses separate 1Password keys for authentication and signing, so `alphero.pub` is not the signing key.

GitHub logs in as whichever account owns the first key it accepts. Without the `sshCommand`, work pushes would authenticate as the adjmunro account and fail with "repository not found". Repos that match neither pattern fall back to the adjmunro identity.

1Password can sign in to both the personal and work accounts at once. The agent offers keys from every vault listed in `agent.toml`, so list only the vaults each machine should use.

## Linux

- 1Password's agent already creates `~/.1password/agent.sock`, so `dot-ssh/config` works unchanged.
- `op-ssh-sign` is at `/opt/1Password/op-ssh-sign`, but `gpg.ssh.program` in `dot-gitconfig` names the macOS path. Before signing there, put the Linux path in an untracked `~/.config/git/linux.gitconfig` and add `[include] path = ~/.config/git/linux.gitconfig` after `[gpg "ssh"]` in `dot-gitconfig`. Git skips the missing file on macOS.
