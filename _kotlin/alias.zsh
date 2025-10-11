#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   koltin/alias   
# --------------------------------------------------------------------------- #

mkmod() {
  local FORCE=0
  local DRY_RUN=0

  # parse flags (supports --force/-f, --dry-run/-n)
  while [[ "$1" == --* || "$1" == -* ]]; do
    case "$1" in
      --force|-f) FORCE=1; shift ;;
      --dry-run|-n) DRY_RUN=1; shift ;;
      --) shift; break ;;
      *) echo "Unknown option: $1"; return 1 ;;
    esac
  done

  local GROUP=$1
  local MODULE=$2

  if [[ -z "$GROUP" || -z "$MODULE" ]]; then
    echo "Usage: mkmod [--force|-f] [--dry-run|-n] <group.dot.path> <:module:submodule>"
    echo "Examples:"
    echo "  mkmod com.orbitremit :domain:util"
    echo "  mkmod --force com.orbitremit :domain:util"
    echo "  mkmod --dry-run com.orbitremit :domain:util"
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

  # directories
  local MAIN_DIR="$MODULE_PATH/src/main/kotlin/$GROUP_PATH/$MODULE_PATH"
  local TEST_DIR="$MODULE_PATH/src/test/kotlin/$GROUP_PATH/$MODULE_PATH"
  local ANDROID_TEST_DIR="$MODULE_PATH/src/androidTest/kotlin/$GROUP_PATH/$MODULE_PATH"
  local KOIN_DEST="$MAIN_DIR/$KOIN_FILENAME.kt"

  # helper: print with colors
  local BOLD="\033[1m"
  local GREEN="\033[0;32m"
  local YELLOW="\033[0;33m"
  local CYAN="\033[0;36m"
  local RESET="\033[0m"

  # helper: safe copy+substitute
  copy_template() {
    local SRC="$1"
    local DEST="$2"

    if [[ ! -f "$SRC" ]]; then
      echo "${YELLOW}⚠️  Template not found: $SRC${RESET}" >&2
      return 1
    fi

    if [[ -f "$DEST" && $FORCE -eq 0 ]]; then
      echo "${CYAN}- Skipped (already exists):${RESET} $DEST"
      return
    fi

    if [[ $DRY_RUN -eq 1 ]]; then
      echo "${YELLOW}- Would create:${RESET} $DEST"
      return
    fi

    mkdir -p "$(dirname "$DEST")"
    sed -e "s|{{MODULE}}|$MODULE|g" \
        -e "s|{{NAMESPACE}}|$NAMESPACE|g" \
        -e "s|{{FILENAME}}|$KOIN_FILENAME|g" \
        "$SRC" > "$DEST"
    echo "${GREEN}- Created:${RESET} $DEST"
  }

  # show summary if dry-run
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "${BOLD}🔍 Dry run mode — no files will be written${RESET}"
  fi

  # create directories (unless dry-run)
  if [[ $DRY_RUN -eq 0 ]]; then
    mkdir -p "$MAIN_DIR" "$TEST_DIR" "$ANDROID_TEST_DIR"
    touch "$TEST_DIR/gitstub" "$ANDROID_TEST_DIR/gitstub"
    echo "${GREEN}- Created:${RESET} $TEST_DIR/gitstub"
    echo "${GREEN}- Created:${RESET} $ANDROID_TEST_DIR/gitstub"
  else
    echo "${YELLOW}- Would create dirs:${RESET} $MAIN_DIR, $TEST_DIR"
    echo "${YELLOW}- Would create:${RESET} $TEST_DIR/gitstub"
    echo "${YELLOW}- Would create:${RESET} $ANDROID_TEST_DIR/gitstub"
  fi

  # copy templates
  copy_template "$DOTFILES/_kotlin/README.md" "$README_FILE"
  copy_template "$DOTFILES/_kotlin/build.gradle.kts" "$MODULE_PATH/build.gradle.kts"
  copy_template "$DOTFILES/_kotlin/KoinModule.kt" "$KOIN_DEST"

  if [[ $DRY_RUN -eq 1 ]]; then
    echo "${BOLD}✅ Dry run complete.${RESET}"
  else
    echo "${BOLD}✅ Module '$MODULE' setup complete under group '$GROUP'.${RESET}"
  fi
}

