#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd "$DIR" > /dev/null
rm -rf $DIR/Hello/build/
rm -rf $DIR/install
mkdir $DIR/install
cmake -S$DIR/Hello -B$DIR/Hello/build -DCMAKE_INSTALL_PREFIX="$DIR/install" -DCMAKE_TOOLCHAIN_FILE=iOS.cmake -GXcode
cmake --build $DIR/Hello/build --config Release --target install

popd > /dev/null
