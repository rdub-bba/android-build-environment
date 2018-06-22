#!/bin/bash

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -f "$SRC_DIR/sdk-packages.cache" ]; then
  $ANDROID_SDK/tools/bin/sdkmanager --list \
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
    > "$SRC_DIR/sdk-packages.cache"
fi

ANDROID_API=26

( \
  cat "$SRC_DIR/sdk-packages.cache" \
    | grep -vE '\<build-tools\>' \
    | grep -vE '\<add-ons;addon-google_apis-google\>' \
    | grep -vE '\<add-ons;addon-google_gdk-google\>' \
    | grep -vE '\<add-ons;addon-google_tv_addon-google\>' \
    | grep -vE '\<platforms;android\>'; \
  cat "$SRC_DIR/sdk-packages.cache" | grep -E "\<build-tools;$ANDROID_API\>"; \
  cat "$SRC_DIR/sdk-packages.cache" | grep -E "\<add-ons;addon-google_apis-google-$ANDROID_API\>"; \
  cat "$SRC_DIR/sdk-packages.cache" | grep -E "\<add-ons;addon-google_gdk-google-$ANDROID_API\>"; \
  cat "$SRC_DIR/sdk-packages.cache" | grep -E "\<add-ons;addon-google_tv_addon-google-$ANDROID_API\>"; \
  cat "$SRC_DIR/sdk-packages.cache" | grep -E "\<platforms;android-$ANDROID_API\>"; \
)> "$SRC_DIR/sdk-packages.list"
