#!/usr/bin/env bash
# Links every <Name>.framework/Headers under an Xcode install into
# path/Frameworks/<Name>, replacing the previous set of links.
#
#   path/symlink.bash [--dry-run] [/Applications/Xcode.app | ...]
#
# --dry-run prints the links it would create and changes nothing.
set -euo pipefail

warn() { printf "\x1b[1;33m[WARN]\x1b[0m %s\\n" "$1" >&2; }
error() {
  printf "\\x1b[1;31m[ERROR]\\x1b[0m %s\\n" "$1" >&2
  exit 1
}

dry_run=false
if [[ ${1:-} == --dry-run ]]; then
  dry_run=true
  shift
fi

xcode_path="${1:-}"
if [[ -z $xcode_path ]]; then
  if [[ -d '/Applications/Xcode-beta.app' ]]; then
    xcode_path='/Applications/Xcode-beta.app'
  elif [[ -d '/Applications/Xcode.app' ]]; then
    xcode_path='/Applications/Xcode.app'
  else
    xcode_path="$(xcode-select --print-path)"
  fi
fi
echo "Xcode path: $xcode_path"
readonly xcode_path

if [[ ! -d $xcode_path ]]; then
  error "
Usage:
  $(basename "$0") [--dry-run] [/Applications/Xcode.app | /Applications/Xcode-beta.app | \$(xcode-select --print-path)]"
fi

# Next to this script, wherever it is run from: a relative ./Frameworks
# would unlink and relink whatever Frameworks dir the caller stands in.
DST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/Frameworks"
readonly DST_DIR

# nproc is GNU coreutils; macOS answers sysctl, other systems getconf.
jobs="$(sysctl -n hw.ncpu 2>/dev/null || getconf _NPROCESSORS_ONLN)"

# Collect the whole new set before touching the old one: the old links are
# removed only once there is a non-empty set to replace them with, so a
# wrong Xcode path or an fd failure can no longer empty the tree.
header_list="$(mktemp)"
trap 'rm -f "$header_list"' EXIT
fd -0 -j "$jobs" -t d -t l 'Headers$' --exclude='AppleTVOS.platform' --exclude='AppleTVSimulator.platform' --exclude='WatchOS.platform' --exclude='WatchSimulator.platform' --exclude='iPhoneOS.platform' --exclude='iPhoneSimulator.platform' --exclude='XROS.platform' --exclude='XRSimulator.platform' --exclude='iOSSupport' --exclude='Python.framework' --exclude='Python3.framework' --exclude='Colloqui' "$xcode_path" >"$header_list"

names=()
targets=()
seen='/'
while IFS= read -r -d '' d; do
  # fd prints directories with a trailing slash; the tracked links have none.
  d="${d%/}"
  # <Name> is the component before the LAST ".framework" in the path
  # (Foo.framework/Versions/A/Headers and A.framework/Frameworks/
  # Foo.framework/Headers both give Foo); a Headers dir outside any
  # framework has no name and is skipped.
  [[ $d == *.framework* ]] || continue
  name="${d%.framework*}"
  name="${name##*/}"
  # The first Headers dir found for a name wins.
  case "$seen" in
    *"/$name/"*) continue ;;
  esac
  seen+="$name/"
  names+=("$name")
  targets+=("$d")
done <"$header_list"

if ((${#names[@]} == 0)); then
  error "no <Name>.framework/Headers found under $xcode_path; $DST_DIR left untouched"
fi

if $dry_run; then
  echo "dry run: would replace the links in $DST_DIR with these ${#names[@]}:"
  for i in "${!names[@]}"; do
    printf '%s -> %s\n' "${names[i]}" "${targets[i]}"
  done
  exit 0
fi

mkdir -p "$DST_DIR"
while IFS= read -r -d '' link; do
  unlink "$link"
done < <(fd -0 --type symlink --hidden --no-ignore . "$DST_DIR")

for i in "${!names[@]}"; do
  if [[ -e "$DST_DIR/${names[i]}" ]]; then
    continue
  fi
  echo "${names[i]}"
  command ln -fs "${targets[i]}" "$DST_DIR/${names[i]}"
done

# DST_DIR="${2:-$(basename "${XCODE_PATH%.*}")}"
# if [[ "$DST_DIR" != 'Xcode' ]]; then
#   DST_DIR="$(basename "$XCODE_PATH")"
# fi

# echo "$DST_DIR"

# if [[ -d "$DST_DIR" ]]; then
#   rm -rf "$DST_DIR"
# fi
# mkdir -p "$DST_DIR"

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
