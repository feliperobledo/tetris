#!/bin/bash

PROJECT_ROOT=`git rev-parse --show-toplevel`
PROVIDERS_DIR_NAME='src/providers'

# These software versions should come from a resource file
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
verify_providers_folder_exists() {
    # Navigate into the 'root' folder from our current location.
    pushd $PROJECT_ROOT
        # Check if there is no third-party folder ...
        if [ ! -d $PROVIDERS_DIR_NAME ]; then
            # ... and if there isn't, create it.
            mkdir $PROVIDERS_DIR_NAME

        fi

        if [ ! -d "$PROVIDERS_DIR_NAME/include" ]; then
            mkdir "$PROVIDERS_DIR_NAME/include"
        fi

        if [ ! -d "$PROVIDERS_DIR_NAME/lib" ]; then
            mkdir "$PROVIDERS_DIR_NAME/lib"
        fi

        if [[ "$OSTYPE" == "darwin"* ]]; then
            if [ ! -d "$PROVIDERS_DIR_NAME/Frameworks" ]; then
                # macOS requires from Framework installation via .dmg files
                mkdir "$PROVIDERS_DIR_NAME/Frameworks"
                echo 'Test created Frameworks folder'
            fi
        fi
    popd
}

# If required, download the SDL library source into the third-party folder.
fetch_third_party_lib_sdl() {
    # Make sure we actually have a third-party folder first.
   verify_providers_folder_exists

    # Navigate into the third-party folder two levels below us.
    pushd $PROJECT_ROOT/$PROVIDERS_DIR_NAME/lib
        # Check to see if there is not yet an SDL folder.
        if [ ! -d "SDL2" ]; then
            echo "Fetching SDL (SDL2: $SDL_VERSION) ..."

            # Download the SDL2 source zip file
            wget https://www.libsdl.org/release/SDL2-$SDL_VERSION.zip

            # Unzip the file into the current folder
            unzip -q SDL2-$SDL_VERSION.zip

            # Rename the SDL2-2.0.9 folder to SDL
            mv SDL2-$SDL_VERSION SDL2

            # Clean up by deleting the zip file that we downloaded.
            rm SDL2-$SDL_VERSION.zip
        else
            echo "SDL library already exists in third party folder."
        fi
    popd
}

fetch_os_specific_providers() {
   verify_providers_folder_exists

    if [[ "$OSTYPE" == "darwin"* ]]; then
        fetch_macOS_frameworks
    fi
}

fetch_macOS_frameworks() {
    # macOS requires from Framework installation via .dmg files
    # Make sure there is a Frameworks folder in the current directory.
    fetch_macOS_SDL_dmg
}

fetch_macOS_SDL_dmg() {
    FRAMEWORKS_ROOT=$PROJECT_ROOT/$PROVIDERS_DIR_NAME/Frameworks
    INCLUES_ROOT=$PROJECT_ROOT/$PROVIDERS_DIR_NAME/include
    SDL_DIR_NAME="SDL2"

    TARGET=$INCLUES_ROOT/$SDL_DIR_NAME
    if [ -d $TARGET ]; then
        echo "SDL header files already exists at $TARGET"
        return
    fi

    # If required, download the SDL2 MacOS Framework into the Frameworks folder.
    pushd $FRAMEWORKS_ROOT
        # Check that there isn't already a framework for SDL
        if [ ! -d "$SDL_DIR_NAME.framework" ]; then
            # Download the .dmg file from the SDL2 download site.
            wget https://www.libsdl.org/release/SDL2-$SDL_VERSION.dmg

            echo "Mounting DMG file ..."
            hdiutil attach SDL2-$SDL_VERSION.dmg

            echo "Copying SDL2.framework from DMG file into the current folder ..."
            cp -R /Volumes/SDL2/SDL2.framework .

            echo "Unmounting DMG file ..."
            hdiutil detach /Volumes/SDL2

            echo "Deleting DMG file ..."
            rm SDL2-$SDL_VERSION.dmg

            # Navigate into the SDL2.framework folder.
            pushd "$SDL_DIR_NAME.framework"
                echo "Code signing SDL2.framework ..."
                codesign -f -s - SDL2
            popd

        else
            echo "SDL Framework already downloaded..."
        fi
    popd

    pushd $INCLUES_ROOT
        if [ ! -d $SDL_DIR_NAME ]; then
            echo "Creating SDL header includes..."
            mkdir $SDL_DIR_NAME

            echo "Copying headers from framework..."
            cp -r $FRAMEWORKS_ROOT/$SDL_DIR_NAME.framework/Headers SDL2
        else
            echo "SDL header files already exist..."
        fi
    popd
}

verify_build_folder_exists() {
    echo "Checking for build folder ..."
    if [ ! -d build ]; then
        mkdir build
    fi
}
