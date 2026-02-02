#!/usr/bin/env bash

case "$BASH_VERSION" in
  0.*|1.*|2.*)
    echo "Bash version is too old. Please upgrade to at least bash 3.0." >&2
    exit 1
  ;;
esac

# as a sanity check, cd into the root of the project
cd "$(dirname "${BASH_SOURCE[0]}")/.." || {
  echo "Couldn't cd into the project root. Did you move the script?" >&2
  exit 1
}

# further sanity check, make sure we are *really* in the project root,
# and that this file is the same as setup/common.sh from the PWD.
[[ "${BASH_SOURCE[0]}" -ef setup/common.sh ]] || {
  echo "Couldn't verify the project root. Did you move the script?" >&2
  exit 1
}


[[ -z "$TMP" ]] && TMP=/tmp/baserom-setup

mkdir -p "$TMP" || exit 1

silent() {
  "$@" &>/dev/null
}

exists() {
  silent type "$@"
}

fail() {
  ansi fg red bold intense >&2
  echo "$@" >&2
  exit 1
}

execd() {
  printf "> "
  echo "$@"
  "$@"
}

check-dependencies() {
  local missing

  for bin in "$@"; do
    exists "$bin" || missing="$missing
$bin"
  done

  if [[ -n "$missing" ]]; then
    msg-fail "Cannot set up the baserom - please install the following to your system:"
    echo "$missing"
    return 1
  fi
}

# basic terminal colour utility
ansi() {
  local mode=fg
  local color=7
  local intensity=normal
  local style=normal

  while [[ $# > 0 ]]; do
    case "$1" in
      fg|bg|reset) mode="$1"; shift ;;
      bold|underline) style="$1"; shift ;;
      black)  color=0; shift ;;
      red)    color=1; shift ;;
      green)  color=2; shift ;;
      yellow) color=3; shift ;;
      blue)   color=4; shift ;;
      purple) color=5; shift ;;
      cyan)   color=6; shift ;;
      white)  color=7; shift ;;
      intense) intensity=intense; shift ;;
    esac
  done

  local tens=3
  local selector='0;'

  case "$mode" in
    reset) printf "\e[0m"; return 0 ;;
    bg) tens=4; selector=''
  esac

  case "$style" in
    bold) selector='1;' ;;
    underline) selector='4;' ;;
  esac

  case "$intensity" in
    intense) tens=9 ;;
  esac

  printf "\e[${selector}${tens}${color}m"
}

msg-info() {
  ansi fg black intense bold
  echo "$@"
  ansi reset
}

msg-success() {
  ansi fg green intense bold
  echo "$@"
  ansi reset
}

msg-fail() {
  ansi fg red bold
  echo "$@"
  ansi reset
}

remove-junk() {
  if (($#)); then
    msg-info "Removing junk files for $TOOLNAME..."

    for junk in "$@"; do
      if [[ -e "$junk" ]]; then
      rm -rf "tools/"$TOOLDIR"/$junk"
      fi
    done
  else
    echo "$TOOLNAME has no junk."
  fi
}

install-docs() {
  if (($#)); then
    local dest=tools/Docs/"$TOOLDIR"
    msg-info "Moving documentation for $TOOLNAME..."

    rm -rf tools/Docs/"$TOOLDIR"

    mkdir -p "$dest"

    for f in "$@"; do
      if [[ -e "$f" ]]; then
        mv tools/"$TOOLDIR"/"$f" "$dest/$f" || true
      fi
    done
  else
    echo "$TOOLNAME has no documentation."
  fi
}

download-tool() {
  local url="$1"; shift
  msg-info "Downloading $TOOLNAME..."
  curl --silent --location --clobber --output "$TMP/$TOOLNAME.zip" "$url"
}

install-tool() {
  local url="$1"; shift
  download-tool "$url" && extract-tool "$@"
}

extract-tool() {
  mkdir -p tools/"$TOOLDIR"
  extract-archive "$TMP/$TOOLNAME.zip" tools/"$TOOLDIR"
}

copy-list() {
  local list="$1"; shift

  msg-info "Copying baserom list file(s) for $TOOLNAME..."

  if [[ -n "$list" ]]; then
    cp "setup/lists/$list" "tools/$TOOLDIR/list.txt" || exit 1
  fi
}

already-setup() {
  local checkfile="$1"; shift
  [[ -z "$checkfile" ]] && checkfile=tools/"$TOOLDIR"/.is_setup

  if [[ -f "$checkfile" ]]; then
    msg-success -n "> $TOOLNAME is already set up in:"
    echo " $(dirname "$checkfile")"
    return 0
  else
    msg-fail "> $TOOLNAME is not set up."
    return 1
  fi
}

mark-done() {
  local checkfile="$1"; shift
  [[ -z "$checkfile" ]] && checkfile=tools/"$TOOLDIR"/.is_setup

  touch "$checkfile"
  msg-success -n "> Successfully set up $TOOLNAME in: "
  dirname "$checkfile"
}


extract-archive() {
  local src="$1"; shift
  local dest="$1"; shift

  # [jneen] Yes i know this adds a dependency on 7z which does not
  # ship by default on most systems. However, the `unzip` utility completely
  # chokes on Callisto's release zip.
  silent 7z x -y -o"$dest" "$src"
}

true

setup-tool() {
  local name="$1"
  local dir="$2"
  local url="$3"
  local list="$4"

  local TOOLNAME=$name
  local TOOLDIR=$dir
  already-setup && return 0
  install-tool $url || return 1
  copy-list $list
  mark-done
}


cleanup-tool() {
  local name="$1"
  local dir="$2"
  shift 2
  local junk=()
  local docs=()

  while (($#)); do
    case "$1" in
      --junk)
        shift
        while (($#)) && [[ "$1" != --docs ]]; do
          junk+=("$1")
          shift
        done
        ;;
      --docs)
        shift
        while (($#)); do
          docs+=("$1")
          shift
        done
        ;;
      *)
        echo "cleanup-tool: unknown argument: $1" >&2
        return 1
        ;;
    esac
  done

  local TOOLNAME=$name
  local TOOLDIR=$dir
  install-docs "${docs[@]}"
  remove-junk "${junk[@]}"
}