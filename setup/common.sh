#!/usr/bin/env bash

# as a sanity check, cd into the root of the project
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

# further sanity check, make sure we are *really* in the project root
[[ -f run-callisto.sh ]] || exit 1

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

setup-flips() {
  local TOOLNAME=Flips
  already-setup && return 0
  install-tool 'https://dl.smwcentral.net/11474/' || return 1
  remove-junk license.txt flips-linux boring.zip src.zip
  mark-done
}

setup-gps() {
  local TOOLNAME=GPS
  already-setup && return 0
  install-tool 'https://dl.smwcentral.net/40056/' || return 1
  install-docs README.txt
  copy-list list_gps.txt
  remove-junk src.zip Changes.txt
  mark-done
}

setup-pixi() {
  local TOOLNAME=PIXI
  already-setup && return 0
  install-tool 'https://dl.smwcentral.net/37432/' || return 1
  copy-list list_pixi.txt
  msg-info "Resolving ASM conflict in PIXI and UberASM Tool..."
  patch -bl "tools/$TOOLNAME/asm/main.asm" setup/pixi/main.asm.patch || return 1
  install-docs README.html
  remove-junk removedResources.txt changelog.txt README.html CONTRIBUTING.html CHANGELOG.html LICENSE
  mark-done
}

setup-lunarmagic() {
  local TOOLNAME='LunarMagic'
  already-setup && return 0
  install-tool 'https://dl.smwcentral.net/40737/' || return 1

  msg-info "Installing baserom User Toolbar alongside Lunar Magic..."
  cp setup/usertoolbar/* tools/"$TOOLNAME"/
  remove-junk readme.txt
  mark-done
}

setup-uberasm() {
  local TOOLNAME=UberASMTool
  already-setup && return 0
  install-tool 'https://dl.smwcentral.net/39036/' || return 1
  install-docs readme.html
  copy-list list_uberasm.txt
  remove-junk readme.txt changelog.txt incompatibilities.txt UberASMTool.dll.config
  mark-done
}

setup-callisto() {
  local TOOLNAME=Callisto
  already-setup && return 0

  install-tool 'https://github.com/Underrout/callisto/releases/download/v0.6.0/callisto-v0.6.0.zip' || return 1

  msg-info "Copying over Callisto's initial BPS patches..."

  local patches=tools/Callisto/initial_patches/LunarMagic3.51

  cp "$patches"/initial_patch_fastrom.bps resources/initial_patches/fastrom.bps
  cp "$patches"/initial_patch_sa1.bps resources/initial_patches/sa1.bps

  msg-info "Replacing tool-specific Asar DLLs with Callisto versions..."

  # [jneen] TODO: proper 64-bit versions of these tools exist, let's try and use them
  local asar64=tools/Callisto/asar/v1.91/64-bit/asar.dll
  local asar32=tools/Callisto/asar/v1.91/32-bit/asar.dll

  cp "$asar64" tools/GPS/
  cp "$asar32" tools/UberASMTool/
  cp "$asar32" tools/AddMusicK/
  rm -f tools/AddMusicK/asar.exe
  cp "$asar64" tools/PIXI/

  install-docs documentation
  remove-junk ASAR_LICENSE LICENSE config asar initial_patches

  mark-done
}

extract-archive() {
  local src="$1"; shift
  local dest="$1"; shift

  # [jneen] Yes i know this adds a dependency on 7z which does not
  # ship by default on most systems. However, the `unzip` utility completely
  # chokes on Callisto's release zip.
  silent 7z x -y -o"$dest" "$src"
}

setup-amk() {
  local TOOLNAME=AddMusicK
  already-setup && return 0

  # manual download step to strip the outer directory from the AMK archive
  download-tool 'https://dl.smwcentral.net/37906/' || return 1
  extract-archive "$TMP/$TOOLNAME.zip" "$TMP" || return 1
  mkdir -p tools/"$TOOLNAME"
  cp -r "$TMP"/AddmusicK_*/* tools/"$TOOLNAME"/

  install-docs readme_files readme.html
  cp setup/lists/Addmusic* tools/AddMusicK/
  remove-junk src.zip addmusicMRemover.pl Makefile asar.exe
  mark-done
}

setup-retry() {
  [[ -f .gitmodules ]] && git submodule update --init

  local TOOLNAME='UberASM/Retry'
  local checkfile=tools/UberASMTool/retry_config/.is_setup

  already-setup "$checkfile" && return 0

  local UBERASM_TOOL_DIR=tools/UberASMTool
  local RETRY_DIR=./includes/retry-system
  local RETRY_CONFIG_DIR=./setup/config/retry_config


  local destdir=tools/UberASMTool/retry_config
  # remove older installation of retry
  [[ -d "$destdir" ]] && rm -rf "$destdir"

  local f
  for f in "$UBERASM_TOOL_DIR"/gamemode/retry_gm*; do
    rm -f "$f"
  done

  cp -r "$RETRY_DIR/src/retry_config" "$UBERASM_TOOL_DIR"/
  cp -r "$RETRY_DIR/src/gamemode" "$UBERASM_TOOL_DIR"/
  cp -r "$RETRY_DIR/src/library" "$UBERASM_TOOL_DIR"/
  cp -r "$RETRY_CONFIG_DIR" "$UBERASM_TOOL_DIR"/
  cp -r "$RETRY_DIR/docs/"* docs/retry-system/

  mark-done "$checkfile"
}

true
