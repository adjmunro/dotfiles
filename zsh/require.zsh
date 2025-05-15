#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh/require
#               return error if arguments are not commands in the system PATH 
# --------------------------------------------------------------------------- #

# Protect against uninstalled command usage.
function require() {
    # ((Arithmetic)) does the number of args ($#) equal 0
    if (( $# == 0 )); then
        error "Error: At least one argument is required."
        return 1;
    fi


    # Iterate over all arguments ($@)
    for foo in "$@"; do
        # command -v "$foo" - check if 'foo' exists in the system PATH
        # > /dev/null       - redirect stdout to null (aka black hole) (discard stdout)
        # 2>&1              - redirect stderr to stdout (/dev/null) (discard stderr)
        # ||                - [logical OR] if LHS fails (returns a non-zero status code), execute RHS
        # { ... }           - an encapsulated block of commands
        command -v "$foo" > /dev/null 2>&1 || {
            error "Require: \"$foo\" is not a recognised command (installed binary, alias, function, builtin etc.)";

            # return with error (non-zero status code)
            return 1;
        }
    done;
}

