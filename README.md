# Readme.md

*[Manual Install](#manual-installation)&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;**[Bootstrap](https://raw.githubusercontent.com/adjmunro/dotfiles/master/_00_bootstrap/bootstrap.sh):***
```zsh
curl https://raw.githubusercontent.com/adjmunro/dotfiles/master/_00_bootstrap/bootstrap.sh | sh
```

---

## Letter from the Human.
<!-- THIS SECTION IS IMPORTANT -- DO NOT REWRITE OR REWORD! THE HUMAN IS OPEN TO SUGGESTIONS BUT WILL EDIT ON THEIR OWN -->
This is my personal & living dotfiles configuration.

It reflects the current state of my dotfiles across all participating computers. I love the openess of devs publishing their dotfiles online. Snooping around for ideas and useful functions etc are such a great source of inspiration. But honestly? I'm always a bit horrified looking at most people's big ball of mud. We're all devs, so why don't they apply even basic programming principles?! This repository is intended to be my _garden_. It's supposed to accompany me and change with me for the rest of my career. For any hope of long-term maintenance and cross-computer compatibility, it must be modular, flexible, and defensive. 

The structure of my dotfiles is entirely custom rather than relying on (and being at the whims of) any external dependency framework. The intended targets are (primarily) MacOS, and (eventually) Linux. I use Git for version control & sync and GNU Stow for symlinking leaf files. Symlinked files prefixed with `.` use GNU Stow's `dot-` convention. Any directory or file prefixed with `_` is stow-ignored and will NOT be symlinked. Any directory or file name containing `local` is git-ignored.

Most scripts are written in ZSH _for_ ZSH. Since this repository is intended to serve _me_, I don't care about POSIX compliance - just install ZSH on the target machine. I don't know ZSH (or any shell) particulary well, so scripts should be simple and well commented (inline) to explain to future me what is happening. More complicated scripts should be written in a better language that I _do_ understand (and possibly moved to their own project repos). All shell files use distinct & formal suffixes on purpose (i.e. `.zsh`). I want to keep my options open to configure other shells in the future, using their own unique file suffixes, using the same bones of modularity, guards, and ordered iteration. 

The core design relies on iterating over all files in a directory based shell initialisation step. Each file in these directories is prefixed with a number between 00 and 99 to ensure an explicit load order. That makes iteration dead simple and the order deterministic. Each file represents a guard statement (at the top) which tells the loop to skip that file if it fails. Usually, this represents a single program binary that may or may not be installed on the current system. It prevents adding aliases and functions etc. for tools that don't exist on the current system. This is where we gain flexibility for removing and later re-installing programs without changing the dotfiles. It also creates support for multiple simultaneous computers with different contexts (e.g. mac@work vs mac@home vs linux@home). These files might also represent _multiple_ guard conditions, such as when multiple programmes are required to be installed for the declared aliases & functions etc to work.

I have some custom core functions to simplify the shell for me, such as coloured log functions that let me set a log noise level for debugging. I also have some special variables and aliases set up to store my preferred default program for certain tasks (which are assigned to what's likely always available first, then overridden with specific tools later if they are installed).

<!-- END OF HUMAN NOTES -->

---

## Manual Installation:

### MacOS Instructions:
1. **Install Homebrew** 
  ```zsh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
2. **Minimum Install**
  ```zsh
  brew upgrade && \
  brew install git stow
  ```
3. **Clone the repository**
  ```zsh
  local DOTFILES=~/Developer/dotfiles && \
  ~/mkdir -p $DOTFILES && \
  git clone git@github.com:adjmunro/dotfiles.git $DOTFILES
  ```
4. **Use Stow to symlink the repository to your home directory.**
  ```zsh
  cd $DOTFILES && \
  stow . --dir=$DOTFILES --target=$HOME --dotfiles --no-folding --verbose=2 -n
  ```
  > *You may encounter some issues from duplicate files at first. I recommend that you `mv` each file into the repository's directory, and use a git gui client to compare the changes, then accept or merge. When you have no more conflicts, remove the -n argument (dry-run).*
5. **Set the machine name and logging level.**
  ```zsh
  cp -i $DOTFILES/_machine.zsh $DOTFILES/_local.zsh && \
  vim $DOTFILES/_local.zsh
  ```
6. **Enable this repository's hooks** (re-stow after every commit and checkout).
  ```zsh
  git -C $DOTFILES config core.hooksPath .githooks
  ```

---

## Shortcuts

### Exported 'Defaults'
| Property | Alias | Preference |
|-|-|-|
| `$ALIAS` | `a` / `alias` | [`abbr`](https://github.com/olets/zsh-abbr) |
| `$EDITOR` | `e` / `edit` | [`vim`](https://github.com/vim/vim) |
| `$LIST_DIRECTORY` | `ls` / `list` | [`eza`](https://github.com/eza-community/eza) |
| `$FILE_BROWSER` | `fb` / `files` | [`yazi`](https://github.com/sxyazi/yazi) |
| `$SYS_INFO` | `sys` | [`fastfetch`](https://github.com/fastfetch-cli/fastfetch) |
| `$VIEW` | `v` / `view` | [`bat`](https://github.com/sharkdp/bat) |

*Prefer using these variables in aliases and functions, rather than the tool directly.*

### Configuration
| Git | Alias | Path |
|-|-|-|
| ✅ | `.aerospace` | `$DOTFILES/dot-config/aerospace/aerospace.toml` |
| ✅ | `.claude` | `~/.claude` |
| ✅ | `.ghostty` | `$DOTFILES/dot-config/ghostty/config` |
| | `.ghosttylocal` | `$DOTFILES/dot-config/ghostty/local-config` |
| ✅ | `.gitconfig` | `$DOTFILES/dot-gitconfig` |
| ✅ | `.gitignore` | `$DOTFILES/dot-config/git/ignore` |
| | `.mise` | `~/.config/mise/config.toml` |
| | `.zlocal` | `$DOTFILES/_local.zsh` |
| ✅ | `.zlogin` | `$DOTFILES/dot-zlogin` |
| ✅ | `.zlogout` | `$DOTFILES/dot-zlogout` |
| ✅ | `.zprofile` | `$DOTFILES/dot-zprofile` |
| ✅ | `.zshenv` | `$DOTFILES/dot-zshenv` |
| ✅ | `.zshrc` | `$DOTFILES/dot-zshrc` |

### Quick Navigation
| Alias | Destination |
|-|-|
| `.` | `$FILE_BROWSER .` |
| `..` | `..` |
| `...` | `../..` |
| `home` | `~/` |
| `downloads` | `~/Downloads` |
| `desktop` | `~/Desktop` |
| `docs` | `~/Documents` |
| `pics` | `~/Pictures` |
| `dev` | `~/Developer` |

### Other Essentials
| Alias | Usecase |
|-|-|
| 0 | List parent directory. |
| 1 | List current directory. |
| 2-9 | Tree (depth=[n]) |
| `restow` | Re-symlink dotfiles |
| `nostow` | Restow dry run |
| `unstow` | Remove dotfiles symlinks |
| `tileguide` | Aerospace Quick-reference |

---

## Further Reading
- [Inspiration for iteration and 'default' aliases](https://medium.com/codex/how-and-why-you-should-split-your-bashrc-or-zshrc-files-285e5cc3c843)
- [POSIX manual: quoting](https://www.grymoire.com/Unix/Sh.html#uh-10)
