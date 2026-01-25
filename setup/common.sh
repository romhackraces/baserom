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
  msg-info "Removing junk files..."

  for junk in "$@"; do
    rm -rf "tools/$TOOLNAME/$junk"
  done
}

install-docs() {
  local dest=tools/Docs/"$TOOLNAME"
  msg-info "Moving $TOOLNAME documentation..."

  rm -rf tools/Docs/"$TOOLNAME"

  mkdir -p "$dest"

  for f in "$@"; do
    mv tools/"$TOOLNAME"/"$f" "$dest/$f"
  done
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
  mkdir -p tools/"$TOOLNAME"
  extract-archive "$TMP/$TOOLNAME.zip" tools/"$TOOLNAME"
}

copy-list() {
  local list="$1"; shift

  msg-info "Copying baserom list file(s) for $TOOLNAME..."

  if [[ -n "$list" ]]; then
    cp "setup/lists/$list" "tools/$TOOLNAME/list.txt" || exit 1
  fi
}

already-setup() {
  local checkfile="$1"; shift
  [[ -z "$checkfile" ]] && checkfile=tools/"$TOOLNAME"/.is_setup

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
  [[ -z "$checkfile" ]] && checkfile=tools/"$TOOLNAME"/.is_setup

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
