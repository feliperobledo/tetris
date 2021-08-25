console-setup:
	./setup.sh console

console-build:
	./build.sh console

console-clean:
	rm -rf targets/**/out targets/**/build

console-run: console-setup console-clean console-build
	./targets/console/out/tetris

clean-all: console-clean
