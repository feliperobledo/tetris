#!/bin/bash

# Include our shared scripts
. scripts/shared_scripts.sh

# The first param is the build target name
TARGET=$1

pushd targets/$1
    ./build.sh
popd
