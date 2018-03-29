#!/bin/bash

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$ANDROID_SDK/tools/bin/sdkmanager --list --include_obsolete \
  | awk '{print $1;}' \
  | grep -E 'tools|build-tools|platform-tools|platforms|cmake|ndk-bundle|add-ons;addon-google_|extras' \
  | grep -v 'extras;intel;Hardware_Accelerated_Execution_Manager' \
  | sort -u \
  > "$SRC_DIR/sdk-packages.list"
