## Setup

### Project Structure:
- The prefix `dot-` will be renamed when symlinked by GNU Stow, hence, `dot-config` is `.config` and `dot-zshrc` is `.zshrc`.
- Directories prefixed with `_` are explicity ignored by GNU Stow and are *not* symlinked (nor are their contents).
- `activate.zsh` contains activation scripts for a package.
- `alias.zsh` contains aliases specific to that package. *Note: aliases with mulitple dependencies should be placed in the `./_combo` directory instead!*
- `env.zsh` set up environment variables for a package.
- `update.zsh` contains that package's upgrade scripts, which are run collectively via the `update` function in `./_zsh`.

### Remote Execution:
Use curl on a fresh install to execute this remote script.
***Note:** This only works for macos at this time.*
TODO: Windows also supports curl by default, but linux may require `apt get` or some other package manager instead. Also this is a homebrew-based installation and doesn't necessarily make sense for other operating systems. Furthermore, the directory paths listed here are macos exclusive and would need to be adjusted for other machines.
TODO: More installations need to be added, or a Brewfile could be added to install all core dependencies.
```
curl https://raw.githubusercontent.com/adjmunro/dotfiles/master/macos-setup.sh | sh
```

#### Installation:
- **[Homebrew](https://brew.sh/) or [Nix Package Manager](https://nix.dev/install-nix)**

  *Currently I use homebrew manually, but I hope to switch to automatic nix installations in the future.*

- **[Git](https://git-scm.com/doc) (Source Control), [GNU Stow](https://www.gnu.org/software/stow/manual/stow.html) (Symlink Farm Manager), and [Ghostty](https://ghostty.org/docs/install/binary#homebrew) (Fast & Simple Config Terminal)**
  ```
  brew install git stow ghostty
  ```
- **Clone the repository**
  ```
  git clone git@github.com:adjmunro/dotfiles.git ~/Developer/dotfiles
  ```
- **Use Stow to symlink the repository to your home directory.**

  You may encounter some issues from duplicate files at first. I recommend that you `mv` each file into the repository's directory, and use a git gui client to compare the changes, then accept or merge. When you have no more conflicts, remove the -nv2 argument (-nv2 = simulate only & verbose level 2).
  ```
  cd ~/Developer/Dotfiles; stow . --target=$HOME --dotfiles -nv2
  ```

#### Local Config:
Some things may support local configuration (i will try to keep this up to date):
- `dot-config/ghostty/local-config` can be used to override the main terminal config
- `dot-zlocal` provides local variables to `.zshenv`, such as 
  ```
  #!/usr/bin/env zsh
  export MACHINE="[home|work|etc]"
  export PROJECT="$HOME/Developer/[most active project]"
  ```

#### Notes:
- Use `la` or `list-aliases` to print a list of all registered aliases. [Read More](https://unix.stackexchange.com/questions/292903/list-names-of-aliases-functions-and-variables-in-zsh)
- `alias X` can be used to print out an alias. <br>
  E.g. `alias zshrc` will show `vim ~/.zshrc`. <br>
  Notably, all substitutions will be completed, allowing you to see the real effect of an aliased command in your current context.
- Use `restart` to re-source all zsh dotfiles.

---
### Next Steps:
- [ ] Customise oh-my-posh prompt
- [ ] Modularise zsh scripts by program & set up for-loop sourcing
- [ ] Create a comprehensive list of core install programs with local override files
- [ ] Investigate Brewfiles or Nix to install programs consistently
- [ ] Create utility functions for zsh
- [ ] Set up fish shell & scripts
- [ ] Add neovim configuration & plugins
- [ ] Add gitconfig and/or investigate sensitive information smudge filters
- [ ] Investigate cross-platform support

### Further Reading

https://medium.com/codex/how-and-why-you-should-split-your-bashrc-or-zshrc-files-285e5cc3c843

https://www.youtube.com/watch?v=y6XCebnB9gs&themeRefresh=1

https://developers.redhat.com/articles/2022/02/02/protect-secrets-git-cleansmudge-filter

https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout

https://www.grymoire.com/Unix/Sh.html#uh-10
