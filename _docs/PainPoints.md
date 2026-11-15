# Migration Pain Points.md

- Porting unpushed / local-only git branches etc.
- Out-of-date & incomplete hombrew scripts / programs -> need an install picker.
- Homebrew tap trust
- Browser tabs, bookmarks, & RSS feeds
- Apple settings (Developer folder, hidden files etc)
- Stow command might be wrong? Seems to link directories, not leaf files
- Which local only files? Where?
  - ~/.claude, ~/.codex, ~/.agents -> hooks, skills, settings, CLAUDE.md, memory, MCP servers, etc
  - Scheduled jobs: break-lock, wake-claude (although those are skill managed)
  - /etc/pam.d/sudo_local/pam_tid.so
  - ~/.config/zsh-abbr/user-abbreviations (is this autobuilt?)
  - ~/.config/jj/.config.toml
  - ~/.config/ghostrealm/config.toml
  - ~/.bash_profile (JAVA_HOME)
  - ~/Library/Services/ three Claude-... Quick Actions?
  - ~/Library/Application\ Support/Google/AndroidStudio2026.2.1/codestyles/alphero.xml, options/, and studio.vmoptions
  - ~/Library/Application\ Support/LogiOptionsPlus/
  - dotfiles *local* e.g. _01_env/50-local.zsh
  - Repos with no remote / unpushed
  - apple-intellgence/, box/, stack-cli, red-energy-sandbox (not git repos)?
  - Documents, Desktop, Downloads, Pictures, etc

Josh suggested making a tarball of all known affected paths for migration. This isn't entirely a dotfiles issue either, since it would contain data that i wouldn't want to commit.
