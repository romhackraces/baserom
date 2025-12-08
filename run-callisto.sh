#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 1

export WINEDEBUG=-all

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
