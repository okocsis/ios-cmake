#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd "$DIR" > /dev/null
rm -rf ./hello-lib/build/
cmake -S./hello-lib -B./hello-lib/build -GXcode -DCMAKE_TOOLCHAIN_FILE=iOS.cmake -DCMAKE_INSTALL_PREFIX=`pwd`/_install
cmake --build ./hello-lib/build --config Release --target install

popd > /dev/null
