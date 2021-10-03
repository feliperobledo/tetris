# Tetris

This is an implementation of tetris that runs in the browser using emscripten and as a standalone window based application.

### System Requirements

1. `bash`
1. `make`
1. `cmake`

**Note**: All development has only been tested on macOS. There is no support for Windows PowerShell at this time.

### Building & Running

#### Console App

1. Open your terminal of choice that supports bash
1. Run `make console-setup`
1. Run `make console-build`
1. Run `./targets/console/out/tetris`

#### Mac App

1. Open your terminal of choice that supports bash
1. Run `make macos-setup`
1. Open `targets/macos/Tetris.xcodeproj`.
1. Click the "Run" button or press Cmd + R

#### iOS App

**WARNING**: under construction

1. Open your terminal of choice that supports bash
1. Run `make ios-setup`
1. Run `make ios-build`
1. TODO: Run the app
