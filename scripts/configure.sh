#!/bin/bash
cd ..;

# check if user choose the debug or release build
if [ "$1" != "Debug" ] && [ "$1" != "Release" ]; then
    echo "Please choose the build type: Debug or Release";
    exit 1;
fi

# check if the build directory exists
if [ ! -d "build" ]; then
    mkdir build;
fi
cd build;

# configure the project
cmake -DCMAKE_BUILD_TYPE=$1 ..;