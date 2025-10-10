#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   koltin/alias   
# --------------------------------------------------------------------------- #

mkmod() {
  local FORCE=0

  # parse flags (supports --force and -f)
  while [[ "$1" == --* || "$1" == -* ]]; do
    case "$1" in
      --force|-f) FORCE=1; shift ;;
      --) shift; break ;;
      *) echo "Unknown option: $1"; return 1 ;;
    esac
  done

  local GROUP=$1
  local MODULE=$2

  if [[ -z "$GROUP" || -z "$MODULE" ]]; then
    echo "Usage: mkmod [--force|-f] <group.dot.path> <:module:submodule>"
    echo "Examples:"
    echo "  mkmod com.orbitremit :domain:util"
    echo "  mkmod --force com.orbitremit :domain:util"
    return 1
  fi

  # build paths
  local GROUP_PATH=$(echo "$GROUP" | tr '.' '/')
  local MODULE_NO_LEAD="${MODULE#\:}"                # remove leading colon if present
  local MODULE_PATH=$(echo "$MODULE_NO_LEAD" | tr ':' '/')
  local MODULE_DOT=$(echo "$MODULE_NO_LEAD" | tr ':' '.')
  local NAMESPACE=$(echo "${GROUP}.${MODULE_DOT}" | tr '[:upper:]' '[:lower:]')

  local README_NAME=$(echo "$MODULE_PATH" | tr '/' '-' | tr '[:lower:]' '[:upper:]')
  local README_FILE="$MODULE_PATH/README-$README_NAME.md"

  # PascalCase for Koin filename (DomainUtil -> KoinDomainUtilModule)
  local ModuleName=$(echo "$MODULE_PATH" | tr '/' ' ' | awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) }}1' | tr -d ' ')
  local KOIN_FILENAME="Koin${ModuleName}Module"

  # ensure directories exist
  mkdir -p "$MODULE_PATH/src/main/kotlin/$GROUP_PATH/$MODULE_PATH"
  mkdir -p "$MODULE_PATH/src/test/kotlin/$GROUP_PATH/$MODULE_PATH"

  # helper: safe copy+substitute
  copy_template() {
    local SRC="$1"
    local DEST="$2"

    if [[ ! -f "$SRC" ]]; then
      echo "Template not found: $SRC" >&2
      return 1
    fi

    if [[ $FORCE -eq 1 || ! -f "$DEST" ]]; then
      sed -e "s|{{MODULE}}|$MODULE|g" \
          -e "s|{{NAMESPACE}}|$NAMESPACE|g" \
          -e "s|{{FILENAME}}|$KOIN_FILENAME|g" \
          "$SRC" > "$DEST"
      echo "- Created: $DEST"
    else
      echo "- Skipped (already exists): $DEST"
    fi
  }

  # copy templates (safe)
  copy_template "$DOTFILES/_kotlin/README.md" \
                "$README_FILE"
  copy_template "$DOTFILES/_kotlin/build.gradle.kts" \
                "$MODULE_PATH/build.gradle.kts"
  copy_template "$DOTFILES/_kotlin/KoinModule.kt" \
                "$MODULE_PATH/src/main/kotlin/$GROUP_PATH/$MODULE_PATH/$KOIN_FILENAME.kt"

  echo "Module '$MODULE' setup complete under group '$GROUP'."
}

