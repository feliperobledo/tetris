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

# Invoke the xcodegen tool to create our project file.
echo "Generating Xcode project"
xcodegen generate
