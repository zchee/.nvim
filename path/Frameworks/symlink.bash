#!/usr/bin/env bash
set -eo pipefail
IFS=$'\n\t'

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

find_framework_header() {
  for d in $(find "$1" -type d -and \( -name 'Headers' -and -not -iwholename '*Python*' \)); do
    if [[ -d "$d" ]]; then
      echo "$(printf $(basename $(echo "$d" | rev | cut -f 1 | awk -F'krowemarf.' '{ print $2 }' | rev)))"
      command ln -fs "$d" "$DST_DIR/$(printf $(basename $(echo "$d" | rev | cut -f 1 | awk -F'krowemarf.' '{ print $2 }' | rev)))"
    fi
  done
}

find_framework_header $XCODE_PATH/Contents/Developer/Library/Frameworks
find_framework_header $XCODE_PATH/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks/
find_framework_header $XCODE_PATH/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/DriverKit19.0.sdk/System/DriverKit/System/Library/Frameworks
find_framework_header $XCODE_PATH/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/Library/Apple/System/Library/Frameworks
find_framework_header $XCODE_PATH/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks
find_framework_header $XCODE_PATH/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks

find_framework_header $XCODE_PATH/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/PrivateFrameworks
find_framework_header $XCODE_PATH/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/PrivateFrameworks
find_framework_header $XCODE_PATH/Contents/Developer/Library/PrivateFrameworks
find_framework_header $XCODE_PATH/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/Developer/Platforms/MacOSX.platform/Developer/Library/PrivateFrameworks
