#!/bin/bash

# Include our shared scripts
. ../../scripts/shared_scripts.sh

# Check that there is a build folder here.
verify_build_folder_exists

# Navigate into the build folder
pushd build
    # Request that CMake configure itself based on what it finds in the parent folder.
    echo "Configuring CMake with Ninja ..."
    cmake -G Ninja ..

    # Start the build process.
    echo "Building project with Ninja ..."
    ninja

    # Copying compile_commands.json to help editor use info to find project inclues
    if [[ -f "compile_commands.json" ]];then
        cp compile_commands.json ../../../compile_commands.json
    else
        echo "WARNING: compile_commands.json not found"
    fi
popd
