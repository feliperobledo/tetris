#!/bin/bash

# Include the shared scripts and utility methods that are common to all platforms.
. ../../scripts/shared_scripts.sh

fetch_brew_dependency "wget"
fetch_brew_dependency "xcodegen"

# Install SDL
fetch_third_party_lib_sdl

# This method will compile a static library from an Xcode project if it doesn't already exist in the Libs folder.
create_static_library() {
    # The following arguments need to be passed into this method:  
    STATIC_LIBRARY=$1
    PROJECT_PATH=$2
    XCODE_PROJECT=$3
    XCODE_TARGET=$4
    BUILD_FOLDER=$5

    # If there is no 'Libs' folder yet, create it.
    if [ ! -d "Libs" ]; then
        mkdir Libs
    fi

    # Navigate into the 'Libs' folder.
    pushd Libs
        # If the static library file doesn't exist, we'll make it.
        if [ ! -e $STATIC_LIBRARY ]; then

          # Navigate to the path containing the Xcode project.
          pushd $PROJECT_PATH
              # Build the iPhone library.
              echo "Building the iOS iPhone static library ..."

              xcrun xcodebuild -configuration "Release" \
                  -project $XCODE_PROJECT \
                  -target 'Static Library-iOS' \
                  -sdk "iphoneos" \
                  build \
                  ONLY_ACTIVE_ARCH=NO \
                  RUN_CLANG_STATIC_ANALYZER=NO \
                  BUILD_DIR="$BUILD_FOLDER" \
                  SYMROOT="$BUILD_FOLDER" \
                  OBJROOT="$BUILD_FOLDER/obj" \
                  BUILD_ROOT="$BUILD_FOLDER" \
                  TARGET_BUILD_DIR="$BUILD_FOLDER/iphoneos"

              # Build the simulator library.
              echo "Building the iOS Simulator static library ..."

              xcrun xcodebuild -configuration "Release" \
                  -project $XCODE_PROJECT \
                  -target 'Static Library-iOS' \
                  -sdk "iphonesimulator" \
                  -arch i386 -arch x86_64 \
                  build \
                  ONLY_ACTIVE_ARCH=NO \
                  RUN_CLANG_STATIC_ANALYZER=NO \
                  BUILD_DIR="$BUILD_FOLDER" \
                  SYMROOT="$BUILD_FOLDER" \
                  OBJROOT="$BUILD_FOLDER/obj" \
                  BUILD_ROOT="$BUILD_FOLDER" \
                  TARGET_BUILD_DIR="$BUILD_FOLDER/iphonesimulator"

              # Join both libraries into one 'fat' library.
              echo "Creating fat library ..."

              xcrun -sdk iphoneos lipo -create \
                  -output "$BUILD_FOLDER/$STATIC_LIBRARY" \
                  "$BUILD_FOLDER/iphoneos/$STATIC_LIBRARY" \
                  "$BUILD_FOLDER/iphonesimulator/$STATIC_LIBRARY"

              echo "The fat static library '$STATIC_LIBRARY' is ready."
            popd
        fi
    popd
}

build_sdl_static_libraries() {
    SDL_LIB_PATH=$1
    BUILD_SCRIPT=$2
    OUTPUT_BUILD_ARTIFACTS=$3

    # If there is no 'Libs' folder yet, create it.
    if [ ! -d "Libs" ]; then
        mkdir Libs
    fi

    pushd $SDL_LIB_PATH
        # Only run the build command if the expected output is not found
        if [ ! -f $OUTPUT_BUILD_ARTIFACTS ]; then
            # run the ios helper build script
            ./build-scripts/$BUILD_SCRIPT

            # There should be a "build" folder which will have our libs.
            # If not, the build process failed.
            if [ ! -d "ios-build" ]; then
                echo "[ERROR] iOS build failed. Check output above"
                popd
                exit -1
            fi
        fi
    popd
}

copy_sdl_static_libraries() {
    TARGET_LIB_PATH=$1
    SDL_ARTIFACTS_PATH=$2

    echo "Copying $TARGET_LIB_PATH into Libs"
    cp $TARGET_LIB_PATH Libs/.

    if [ -f $TARGET_LIB_PATH/libSDL2main.a ]; then
        echo "Copying $SDL_ARTIFACTS_PATH/libSDL2main.a into Libs"
        cp $SDL_ARTIFACTS_PATH/libSDL2main.a Lib
    else
        # The SDL ios docs say a libSDL2main.a should be generated. 
        # However, I haven't seen it yet.
        echo "[WARNING] $SDL_ARTIFACTS_PATH/libSDL2main.a not found..."
    fi
}

SDL_LIB_PATH="../../src/providers/lib/SDL2"
IOS_BUILD_LIB_DIR_NAME="ios-build"
IOS_BUILD_SCRIPT_NAME="iosbuild.sh"
IOS_SDL_LIB_FILENAME="libSDL2.a"
IOS_TARGET_LIB_PATH="$IOS_BUILD_LIB_DIR_NAME/lib/$IOS_SDL_LIB_FILENAME"


build_sdl_static_libraries\
    $SDL_LIB_PATH\
    $IOS_BUILD_SCRIPT_NAME\
    $IOS_TARGET_LIB_PATH

# This static library is a must
copy_sdl_static_libraries\
    "$SDL_LIB_PATH/$IOS_TARGET_LIB_PATH"\
    "$SDL_LIB_PATH/$BUILD_ARTIFACTS_DIRECTORY/lib/"

# Create our main SDL2 static library if necessary and put it into the Libs folder.

# XCODE_TARGET='Static Library-iOS'
# XCODE_PROJECT_PATH="$SDL_LIB_PATH/Xcode/SDL"
# XCODE_PROJECT_NAME="SDL.xcodeproj"
# BUILD_FOLDER="build/SDL"
# create_static_library\
#     $IOS_SDL_LIB_FILENAME\
#     "../$XCODE_PROJECT_PATH"\
#     $XCODE_PROJECT_NAME\
#     $XCODE_TARGET\
#     $BUILD_FOLDER
# 
# copy_sdl_static_libraries\
#     $XCODE_PROJECT_PATH/Library-iOS/$IOS_SDL_LIB_FILENAME\
#     $SDL_LIB_PATH/$BUILD_FOLDER

# Invoke the xcodegen tool to create our project file.
echo "Generating Xcode project"
xcodegen generate
