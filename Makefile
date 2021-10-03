
# ========================================
# console target
# ========================================
console-setup:
	./setup.sh console

console-build:
	./build.sh console

console-clean:
	rm -rf targets/console/out targets/console/build

console-run: console-setup console-clean console-build
	./targets/console/out/tetris

# ========================================
# macos target
# ========================================
macos-setup:
	./setup.sh macos

macos-clean:
	rm -rf targets/macos/Generated targets/macos/*.xcodeproj


# ========================================
# ios target
# ========================================
ios-setup:
	./setup.sh ios

ios-build: ios-clean-build
	./build.sh ios

ios-clean-build:
	rm -rf targets/ios/build

ios-clean-sdl:
	rm -rf src/providers/lib/SDL2/ios-build/lib
	rm -rf src/providers/lib/SDL2/Xcode/SDL/Library-iOS

ios-clean-project:
	rm -rf targets/ios/Generated
	rm -rf targets/ios/Libs
	rm -rf targets/ios/*.xcodeproj

ios-clean-all: ios-clean-project ios-clean-sdl ios-clean-build

# ========================================
# misc commands
# ========================================
clean-all: console-clean
