#!/bin/bash
set -e

XCODE_PATH=$1

if [[ -z $XCODE_PATH ]]; then
  echo "USAGE: $0 [Xcode.app path]"
  exit 1
fi

DST_DIR="$(basename "${XCODE_PATH%.*}")"
if [[ -d "$DST_DIR" ]]; then
  rm -rf "$DST_DIR"
fi
mkdir -p "$DST_DIR"

for d in $(find "$XCODE_PATH/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks" -maxdepth 1 -type d); do
  if [[ -d "$d/Headers" ]]; then
    command ln -fs "$d/Headers" "$DST_DIR/$(printf $(basename $d) | awk -F. '{print $1}')"
  fi
done
