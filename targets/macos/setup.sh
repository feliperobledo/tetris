#!/bin/bash

# Include our shared scripts
. ../../scripts/shared_scripts.sh

# Ask Homebrew to fetch our required programs
fetch_brew_dependency "wget"
fetch_brew_dependency "xcodegen"

# Install SDL
fetch_third_party_lib_sdl

# Install OS specific resources
fetch_os_specific_providers

# Check to see if we have an existing symlink to our shared main C++ source folder.
# TODO: delete the code below if the "sources" config of the project.yml works
#       normally when pointing to source files in directories above the
#       PROJECT_DIR
# if [ ! -d "Source" ]; then
#    echo "Linking 'Source' path to '../../src/core/"
#    ln -s ../../src/core Source
#fi

# Invoke the xcodegen tool to create our project file.
echo "Generating Xcode project"
xcodegen generate
