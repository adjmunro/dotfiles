# Agents.md

> !! IMPORTANT !! This repository is PUBLIC and therefore must not commit personal information or private keys etc. 

You may edit this file (and linked Markdown files) with painful lessons you have learnt if, while working, you encounter a tooling issue that sidetracks you from achieving your goals or something non-obvious, e.g.: 
(a) you took many (3+) turns understand something; 
(b) you had to ask a human for clarification; 
(c) you misunderstood something and required correction.

Keep your edits succinct: a human MUST review your changes!

## Conventions
- You MUST read [Git.md](_docs/GIT.md) before working using git or any git-related tool!
- Cut puffery and exposition, keep things short and concise. Say what it does, not how it feels.
- Follow the British English for inline comments, documentation, and code. Use Oxford commas.
- Descriptive comments are encouraged; clarity beats cleverness.
- Any file or directory prefixed with `_` is ignored by GNU Stow when symlinking.
- Any file or directory containing `local` is ignored by Git (except `.stow-local-ignore`)

## Debugging
Startup logging is controlled by `$LOG_LEVEL` (see [logger](_libs/logger.zsh)). Non-interactive shells are forced to `$LOG_ERROR`. To see warnings or debug output, run `LOG_LEVEL=LOG_DEBUG zsh -ic exit`.
