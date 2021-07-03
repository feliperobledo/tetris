#!/bin/bash

# Include the shared scripts from the parent folder.
source ./scripts/shared_scripts.sh

# Ask Homebrew to fetch our required programs
fetch_brew_dependency "wget"
fetch_brew_dependency "cmake"
fetch_brew_dependency "ninja"
