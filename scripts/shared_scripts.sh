#!/bin/bash

PROJECT_ROOT=`git rev-parse --show-toplevel`
PROVIDERS_DIR_NAME='providers'

SDL_VERSION='2.0.14'

# Alias the 'pushd' command and have it send its output to the abyss ...
pushd() {
    command pushd "$@" > /dev/null
}

# Alias the 'popd' command and have it send its output to the abyss ...
popd() {
    command popd "$@" > /dev/null
}

# Given the name of a Homebrew formula, check if its installed and if not, install it.
fetch_brew_dependency() {
    FORMULA_NAME=$1

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        echo "Fetching Brew dependency: '$FORMULA_NAME'."
        if brew ls --versions $FORMULA_NAME > /dev/null; then
            echo "Dependency '$FORMULA_NAME' is already installed, continuing ..."
        else
            echo "Dependency '$FORMULA_NAME' is not installed, installing via Homebrew ..."
            brew install $FORMULA_NAME
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo 'Linux is unsupported at the moment'
    elif [[ "$OSTYPE" == "win32" ]]; then
        echo 'win32 is unsupported at the moment'
    else
        echo 'your OS is unsupported'
            # Unknown.
    fi
}

# If nothing has created the third-party folder yet, then we'll create it.
verify_third_party_folder_exists() {
    # Navigate into the 'root' folder from our current location.
    pushd $PROJECT_ROOT
        # Check if there is no third-party folder ...
        if [ ! -d $PROVIDERS_DIR_NAME ]; then
            # ... and if there isn't, create it.
            mkdir $PROVIDERS_DIR_NAME
            mkdir $PROVIDERS_DIR_NAME/include
            mkdir $PROVIDERS_DIR_NAME/lib
        fi
    popd
}

# If required, download the SDL library source into the third-party folder.
fetch_third_party_lib_sdl() {
    # Make sure we actually have a third-party folder first.
    verify_third_party_folder_exists

    # Navigate into the third-party folder two levels below us.
    pushd $PROJECT_ROOT/$PROVIDERS_DIR_NAME/lib
        # Check to see if there is not yet an SDL folder.
        if [ ! -d "SDL" ]; then
            echo "Fetching SDL (SDL2: $SDL_VERSION) ..."

            # Download the SDL2 source zip file
            wget https://www.libsdl.org/release/SDL2-$SDL_VERSION.zip

            # Unzip the file into the current folder
            unzip -q SDL2-$SDL_VERSION.zip

            # Rename the SDL2-2.0.9 folder to SDL
            mv SDL2-$SDL_VERSION SDL

            # Clean up by deleting the zip file that we downloaded.
            rm SDL2-$SDL_VERSION.zip
        else
            echo "SDL library already exists in third party folder."
        fi
    popd
}
