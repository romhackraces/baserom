#!/usr/bin/env bash

. "$(dirname "$0")"/setup/common.sh || exit 1

setup-all() {
  setup-amk || fail "Could not set up AddmusicK"
  setup-flips || fail "Could not set up Flips"
  setup-gps || fail "Could not set up GPS"
  setup-pixi || fail "Could not set up PIXI"
  setup-lunarmagic || fail "Could not set up Lunar Magic"
  setup-uberasm || fail "Could not set up UberASMTool"
  setup-callisto || fail "Could not set up Callisto"
  setup-retry || fail "Could not set up Retry"
}

check-dependencies curl 7z patch || exit $?

setup-all
