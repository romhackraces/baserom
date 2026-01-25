#!/usr/bin/env bash

. "$(dirname "$0")"/setup/common.sh || exit 1
. "$(dirname "$0")"/setup/tool_specific.sh || exit 1

setup-tools() {
  setup-amk || fail "Could not set up AddmusicK"
  setup-flips || fail "Could not set up Flips"
  setup-gps || fail "Could not set up GPS"
  setup-pixi || fail "Could not set up PIXI"
  setup-lunarmagic || fail "Could not set up Lunar Magic"
  setup-uberasm || fail "Could not set up UberASMTool"
  setup-callisto || fail "Could not set up Callisto"
}

check-dependencies curl 7z patch || exit $?

setup-tools
