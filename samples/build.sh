#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd "$DIR" > /dev/null
rm -rf ./Hello/build/
rm -rf ./install
mkdir install
cmake -S./Hello -B./Hello/build -GXcode -DCMAKE_TOOLCHAIN_FILE=iOS.cmake
cmake DESTDIR="./install" --build ./Hello/build --config Release --target install

popd > /dev/null
