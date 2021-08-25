console:
	./build.sh console

clean-console:
	rm -rf targets/**/out targets/**/build

run-console: clean-console console
	./targets/console/out/tetris

clean-all: clean-console
