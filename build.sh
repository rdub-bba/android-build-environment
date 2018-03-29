#!/bin/bash

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TAG="$2"
if [ -z "$TAG" ]; then
  TAG="latest"
fi

docker build \
  -t android-build-environment:$TAG \
  "$SRC_DIR"
