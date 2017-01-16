#!/bin/bash
set -e

XCODE_PATH=$1

if [[ -z $XCODE_PATH ]]; then
  echo "USAGE: $0 [Xcode.app path]"
  exit 1
fi

for d in $(find "$XCODE_PATH/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks" -maxdepth 1 -type d); do
  if [[ -d "$d/Headers" ]]; then
    ln -s "$d/Headers" "$(printf $(basename $d) | awk -F. '{print $1}')"
  fi
done
