#!/usr/bin/env bash
set -eo pipefail

warn() { printf "\x1b[1;33m[WARN]\x1b[0m %s\\n" "$1" >&2; }

XCODE_PATH=$1

if [[ -z $XCODE_PATH ]]; then
  echo "USAGE: $(basename "$0") [Xcode.app path]"; exit 1
fi

DST_DIR="${2:-$(basename "${XCODE_PATH%.*}")}"
if [[ -d "$DST_DIR" ]]; then
  rm -rf "$DST_DIR"
fi
mkdir -p "$DST_DIR"

# _find_framework_header() {
#   for d in $(find "$1" -type d -and \( -name 'Headers' -and -not -iwholename '*Python*' \)); do
#     if [[ -d "$d" ]]; then
#       HEADER_NAME="$(printf "%s" $(basename $(echo "$d" | rev | cut -f 1 | awk -F'krowemarf.' '{ print $2 }' | rev)))"
#       if [[ ! -d "$DST_DIR/$HEADER_NAME" ]]; then
#         echo "$HEADER_NAME"
#         command ln -fs "$d" "$DST_DIR/$HEADER_NAME"
#       fi
#     fi
#   done
# }
# find_framework_header "${XCODE_PATH}/Contents/Developer/Library/Frameworks"
# find_framework_header "${XCODE_PATH}/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks/"
# find_framework_header "${XCODE_PATH}/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/DriverKit19.0.sdk/System/DriverKit/System/Library/Frameworks"
# find_framework_header "${XCODE_PATH}/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/Library/Apple/System/Library/Frameworks"
# find_framework_header "${XCODE_PATH}/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks"
# find_framework_header "${XCODE_PATH}/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks"
# 
# find_framework_header "${XCODE_PATH}/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/PrivateFrameworks"
# find_framework_header "${XCODE_PATH}/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/PrivateFrameworks"
# find_framework_header "${XCODE_PATH}/Contents/Developer/Library/PrivateFrameworks"
# find_framework_header "${XCODE_PATH}/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/Developer/Platforms/MacOSX.platform/Developer/Library/PrivateFrameworks"

find_framework_header() {
  for d in $(fd -j $(nproc) -t d -t l 'Headers$' --exclude='AppleTVOS.platform' --exclude='AppleTVSimulator.platform' --exclude='WatchOS.platform' --exclude='WatchSimulator.platform' --exclude='iPhoneOS.platform' --exclude='iPhoneSimulator.platform' --exclude='iOSSupport' --exclude='Python.framework' --exclude='Python3.framework' --exclude='Colloqui' "$1"); do
    HEADER_NAME="$(printf "%s" $(basename $(echo "$d" | rev | cut -f 1 | awk -F'krowemarf.' '{ print $2 }' | rev)))"
    if [[ -d "$DST_DIR/$HEADER_NAME" ]]; then
      continue
    fi
    echo "$HEADER_NAME"
    command ln -fs "$d" "$DST_DIR/$HEADER_NAME"
  done
}

find_framework_header "$XCODE_PATH"
