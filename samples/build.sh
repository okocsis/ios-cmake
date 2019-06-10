#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd "$DIR" > /dev/null
PROJ_DIR="$DIR/Hello/"
BUILD_DIR="$DIR/build/"
INSTALL_DIR="$DIR/install"

rm -rf $BUILD_DIR
rm -rf $INSTALL_DIR
mkdir $INSTALL_DIR

cmake -S$PROJ_DIR \
      -B$BUILD_DIR \
      -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
      -DBUILD_SHARED_LIBS="OFF" \
      -DCMAKE_TOOLCHAIN_FILE=iOS.cmake \
      -GXcode

cmake --build $BUILD_DIR \
      --config Release \
      --target install

popd > /dev/null
