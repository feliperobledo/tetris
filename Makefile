
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

# ========================================
# misc commands
# ========================================
clean-all: console-clean
