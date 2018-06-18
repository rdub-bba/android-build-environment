#!/bin/bash

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$ANDROID_SDK/tools/bin/sdkmanager --list --include_obsolete \
  | awk '{print $1;}' \
  | grep -vE '\<system-images\>' \
  | grep -vE '\<sources\>' \
  | grep -vE '\<lldb\>' \
  | grep -vE '\<extras;android;gapid\>' \
  | grep -v 'extras;intel;Hardware_Accelerated_Execution_Manager' \
  | grep -v 'extras;google;simulators' \
  | grep -v 'extras;google;webdriver' \
  | grep -v 'docs' \
  | grep -v 'emulator' \
  | grep -v 'extras;google;auto' \
  | grep -v 'extras;google;webdriver' \
  | sort -u \
  > "$SRC_DIR/sdk-packages.list"
