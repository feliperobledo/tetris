# Tools

Here I record all the new tools I've picked up during the development of my own version of tetris. Happy learning!

## otool

This can give me wide variety of information from a given binary. For example, I can run:

```bash
➜ otool -L out/tetris
out/tetris:
        @rpath/SDL2.framework/Versions/A/SDL2 (compatibility version 1.0.0, current version 15.0.0)
        /System/Library/Frameworks/OpenGL.framework/Versions/A/OpenGL (compatibility version 1.0.0, current version 1.0.0)
        /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 905.6.0)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1292.100.5)
```

`otool` will read the section of the Mach-O formatted file to pick up on which dynamic libraries are loaded.

## install_name_tool

This tool can help with changing the name and location of a lybrary loaded by a binary file with Mach-O format.
