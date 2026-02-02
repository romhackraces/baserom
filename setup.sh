#!/usr/bin/env bash

. "$(dirname "$0")"/setup/common.sh || exit 1
. "$(dirname "$0")"/setup/extra.sh || exit 1

check-dependencies curl 7z patch jq || exit $?

TOOLDATA=$(dirname "$0")/setup/tools.json

# Setup
jq -c '.tools[]' $TOOLDATA | while read -r tool; do
  name=$(jq -r '.name' <<< "$tool")
  dir=$(jq -r '.dir' <<< "$tool")
  url=$(jq -r '.url' <<< "$tool")
  list=$(jq -r '.list' <<< "$tool")

  setup-tool "$name" "$dir" "$url" "$list" || fail "Could not set up $name"

done

# Extra
msg-info -n "Running additional setup functions for specific tools..."
extra-amk
extra-pixi
extra-lunarmagic
extra-callisto
msg-success -n "> Successfully completed additional setup."

# Cleanup
msg-info -n "Running clean up functions for tools..."
jq -c '.tools[]' $TOOLDATA | while read -r tool; do
  name=$(jq -r '.name' <<< "$tool")
  dir=$(jq -r '.dir' <<< "$tool")
  mapfile -t junk < <(jq -r '.junk[]?' <<< "$tool")
  mapfile -t docs < <(jq -r '.docs[]?' <<< "$tool")

  cleanup-tool "$name" "$dir" --junk "${junk[@]}" --docs "${docs[@]}" || fail "Could not clean up $name"

done

msg-success -n "> Successfully cleaned up tool installations."

