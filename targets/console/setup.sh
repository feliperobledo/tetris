#!/bin/bash

# Include the shared scripts from the parent folder.
. ../../scripts/shared_scripts.sh

# Ask Homebrew to fetch our required programs
fetch_brew_dependency "wget"
fetch_brew_dependency "cmake"
fetch_brew_dependency "ninja"

# Install SDL
fetch_third_party_lib_sdl

# Install OS specific resources
fetch_os_specific_providers
