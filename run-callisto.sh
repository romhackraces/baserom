#!/usr/bin/env bash

. "$(dirname "$0")"/setup/common.sh || exit 1

check-dependencies wine || exit $?

case $(wine --version) in
  wine-9.*|wine-10.*)
    msg-fail "WARNING: Lunar Magic reloading will not work in wine <= 10. Please upgrade to wine 11."
esac

export WINEDEBUG=-all
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

callisto() {
  exec wine tools/Callisto/callisto.exe "$@"
}

rm -rf workspace/temp
mkdir -p workspace/temp
cp -r workspace/Graphics workspace/temp/Graphics
cp -r workspace/ExGraphics workspace/temp/ExGraphics

if [[ $# == 0 ]]; then
  callisto update
else
  callisto "$@"
fi
