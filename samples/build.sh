#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd "$DIR" > /dev/null
rm -rf ./Hello/build/
cmake -S./Hello -B./Hello/build -GXcode -DCMAKE_TOOLCHAIN_FILE=iOS.cmake
cmake --build ./Hello/build --config Release --target install

popd > /dev/null
