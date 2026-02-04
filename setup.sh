#!/usr/bin/env bash

. "$(dirname "$0")"/setup/common.sh || exit 1
. "$(dirname "$0")"/setup/extra.sh || exit 1

check-dependencies curl 7z patch jq || exit $?

# GLOBAL DEFINES
TOOLSDATA=$(dirname "$0")/setup/tools.json
TOOLSDIR=$(dirname "$0")/tools

# Run setup for each tool
jq -c '.tools[]' $TOOLSDATA | while read -r tool; do
  name=$(jq -r '.name' <<< "$tool")
  dir=$(jq -r '.dir' <<< "$tool")
  url=$(jq -r '.url' <<< "$tool")
  list=$(jq -r '.list' <<< "$tool")

  setup-tool "$name" "$dir" "$url" "$list" || fail "Could not set up $name"

done

# Run extra setup steps
msg info "Running additional setup functions for specific tools..."
tools=("AddmusicK" "PIXI" "LunarMagic" "Callisto")
for tool in "${tools[@]}"; do
    extra-steps "$tool"
done
msg success "> Successfully completed additional setup."

# Cleanup
msg info "Running clean up functions for tools..."
jq -c '.tools[]' $TOOLSDATA | while read -r tool; do
  name=$(jq -r '.name' <<< "$tool")
  dir=$(jq -r '.dir' <<< "$tool")
  mapfile -t junk < <(jq -r '.junk[]?' <<< "$tool")
  mapfile -t docs < <(jq -r '.docs[]?' <<< "$tool")

  cleanup-tool "$name" "$dir" --junk "${junk[@]}" --docs "${docs[@]}" || fail "Could not clean up $name"

done

msg success "> Successfully cleaned up tool installations."

