#!/bin/bash

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DATE_TAG="$2"
if [ -z "$DATE_TAG" ]; then
  DATE_TAG=`date "+%Y%m%d"`
fi

docker build \
  -t android-build-environment:$DATE_TAG \
  "$SRC_DIR"
