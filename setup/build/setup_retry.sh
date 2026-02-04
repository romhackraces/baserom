#!/usr/bin/env bash

# [AmperSam] setting up the retry is only done from source
setup-retry() {
  local TOOLNAME='Retry System'

  local UBERASM_TOOL_DIR=tools/UberASMTool
  local RETRY_DIR=./includes/retry-system
  local RETRY_CONFIG_DIR=./setup/config/retry_config

  # update the retry git submodule
  [[ -f .gitmodules ]] && git submodule update --init -v

  # remove older installation of retry
  msg info "Removing older version of $TOOLNAME"
  local destdir=tools/UberASMTool/retry_config
  [[ -d "$destdir" ]] && rm -rf "$destdir"

  # copy over latest version of retry
  msg info "Upgrading $TOOLNAME files"
  local f
  for f in "$UBERASM_TOOL_DIR"/gamemode/retry_gm*; do
  rm -f "$f"
  done
  cp -r "$RETRY_DIR/src/retry_config" "$UBERASM_TOOL_DIR"/
  cp -r "$RETRY_DIR/src/gamemode" "$UBERASM_TOOL_DIR"/
  cp -r "$RETRY_DIR/src/library" "$UBERASM_TOOL_DIR"/

  # copy over baserom's retry config
  msg info "Copying Baserom configuration for $TOOLNAME"
  cp -r "$RETRY_CONFIG_DIR" "$UBERASM_TOOL_DIR"/

  # copy over retry documentation
  msg info "Copying $TOOLNAME to documentation"
  cp -r "$RETRY_DIR/docs/"* docs/retry-system/
}