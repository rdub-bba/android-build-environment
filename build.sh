#!/bin/bash

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DATE_TAG=`date "+%Y%m%d"`
docker build \
  -t android-build-environment:latest \
  -t android-build-environment:$DATE_TAG \
  "$SRC_DIR"
