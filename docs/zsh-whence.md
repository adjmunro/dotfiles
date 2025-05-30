# Identifying Commands
There are a number of ways to identify if a command is builtin, binary, alias, hashed path, reserved word, shell function, or doesn't exist. This document demonstrates some of the options.

It's important to remember that in a shell environment that you control, it's not worth getting worked up over POSIX compliance - since it's your computer and you know zshell, then just install zshell.

I recommend, therefore, using `whence` within the zshell ecosystem. If seeking POSIX-compliance and cross-shell compatibility, then `command` and `type` are builtins available in almost every shell. You should avoid `which` and `hash` which are often implemented by external functions and thus much slower.

## Whence
*Whence appears to be the primary command in zshell, with most other commands being aliases of whence with specific arguments combinations. Within the zshell ecosystem, it's a powerful builtin-type function, however using whence is not POSIX compliant nor compatible with most other shells.*

`whence [ -vcwfpamsS ] [ -x num ] name ...`

For each name, indicate how it would be interpreted if used as a command name. 

If name is not an alias, built-in command, external command, shell function, hashed command, or a reserved word, the exit status shall be non-zero, and -- if `-v`, `-c`, or `-w` was passed -- a message will be written to standard output.  (This is different from other shells that write that message to standard error.)

*Whence accepts vararg arguments, but only returns successfully if all arguments are valid.*
```zsh
> whence xxx ls if edit type update
/bin/ls
if
$EDITOR
type
update
```

*`-v` produces a verbose report.*
```zsh
> whence -v xxx ls if edit type update
xxx not found
ls is /bin/ls
if is a reserved word
edit is an alias for $EDITOR
type is a shell builtin
update is a shell function from /Users/adjmunro/Developer/dotfiles/zsh/update.zsh
```

*`-w` associates the name with it's type.*
```zsh
> whence -w xxx ls if edit type update
xxx: none
ls: command
if: reserved
edit: alias
type: builtin
update: function
```

*`-c` is a verbose csh-like format, but it's also a bit of a mish-mash of outputs - roughly equivalent to `-wf` but with a more informative alias output.*
```zsh
> whence -c xxx ls if edit type update
xxx not found
/bin/ls
if: shell reserved word
edit: aliased to $EDITOR
type: shell built-in command
update () {
        debug "----------------------------------"
        for f in $DOTFILES/zsh/*/update.zsh
        do
                source $f
                debug "----------------------------------"
        done
        require neofetch && neofetch
}
```

*`-f` prints the contents of shell functions.*
```zsh
> whence -f xxx ls if edit type update
/bin/ls
if
$EDITOR
type
update () {
        debug "----------------------------------"
        for f in $DOTFILES/zsh/*/update.zsh
        do
                source $f
                debug "----------------------------------"
        done
        require neofetch && neofetch
}
```

*`-x [num]` defines the number of spaces per tab indent when using `-f` or `-c` to print shell functions.*
```zsh
> whence -fx 4 update
update () {
    debug "----------------------------------"
    for f in $DOTFILES/zsh/*/update.zsh
    do
        source $f
        debug "----------------------------------"
    done
    require neofetch && neofetch
}
```

*`-p` only searches for binary paths, even if the name matches an alias, builtin, reserved word, or shell function.*
```zsh
> whence -p xxx ls if edit type update
/bin/ls
/usr/bin/type

> whence -pv xxx ls if edit type update
xxx not found
ls is /bin/ls
if not found
edit not found
type is /usr/bin/type
update not found
```

*`-a` Searches for ALL occurrances of name (normally only the first result is printed).*
```zsh
> whence -a xxx ls if edit type update
/bin/ls
if
$EDITOR
type
/usr/bin/type
update
```

*`-m` accepts arguments as patterns (must be quoted)*.
```zsh
> whence -m "*ar"
/usr/bin/ar
/usr/bin/bsdtar
/usr/bin/calendar
/usr/bin/clear
/usr/bin/jar
/usr/bin/ptar
/opt/homebrew/bin/scalar
/usr/bin/shar
/usr/bin/tar
/usr/bin/xar
```

*`-s` prints path symlinks. `-S` resolves multiple symlinks and prints intermediate steps.*
```zsh
> whence -as xxx ls if edit type update
/bin/ls -> /bin/ls
if
$EDITOR
type
/usr/bin/type -> /usr/bin/type
update
```

## Alternatives to Whence
| Alternative | Equivalent To |
| - | - |
| `command -v ...` | `whence ...` |
| `command -V ...` | `whence -v ...` |
| `type [ -wfpamsS ] ...` | `whence -v ...` |
| `where [ -wpmsS ] [ -x num ] ...` | `whence -ca ...` |
| `which [ -wpamsS ] [ -x num ] ...` | `whence -c ...` |

