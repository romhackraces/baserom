#!/usr/bin/env bash
. "$(dirname "$0")"/setup/common.sh || exit 1
. "$(dirname "$0")"/setup/build/setup_retry.sh || exit 1

setup-all() {
  setup-retry || fail "Could not set up Retry"
}

setup-all
