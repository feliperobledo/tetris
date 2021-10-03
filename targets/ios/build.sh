xcrun xcodebuild build \
  -project "Tetris.xcodeproj" \
  -target 'Tetris' \
  -configuration "Debug" \
  -sdk "iphonesimulator14.5" \
  # -arch i386 -arch x86_64 \
  build \
  # ONLY_ACTIVE_ARCH=NO \
  RUN_CLANG_STATIC_ANALYZER=NO \
  BUILD_DIR="build" \
  SYMROOT="build" \
  OBJROOT="build/obj" \
  BUILD_ROOT="build" \
  TARGET_BUILD_DIR="build/iphonesimulator"
