cbGL by Tapio Vierros
---------------------

This project allows the usage of OpenGL hardware accelerated graphics in CoolBasic.
It is achieved by creating a wrapper DLL with FreeBASIC and accompanying it with a relevant CoolBasic source code library.

The project is incomplete, but allows for fast 2d graphics primitives, images (with rotation, scaling and alpha-support) as well as bitmap text. Basic 3d is also possible (see ported NeHe examples and WrappedOpenGLcmds.txt).
Note that CoolBasic's own graphics commands are not available when using this library (as this doesn't use CB's window, but hides it and creates its own).

LICENSE: Free to use for anything.

