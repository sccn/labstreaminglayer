# LSL build environment

liblsl and most apps use [CMake](#CMake) and C++.

## Recommended compiler toolchain

Download a toolchain. The following platforms are the primary test targets:

  - Alternatively, you can install the [Visual Studio 2017](https://www.visualstudio.com/downloads/) IDE with the Visual Studio 2015 compiler toolset.
- Ubuntu Linux 16.04, 18.04
  - Clang 3.5
  - GCC 6.2
- MacOS Sierra, High Sierra
  - XCode 8.3, 9.3
- Windows 7, Windows 10
  - [Visual Studio 2017](https://visualstudio.com/downloads)
  To get a minimal installation, copy this block into a file and use "Import configuration"
  in the installer:


```
{
	"version": "1.0",
	"components": [
		"microsoft.visualstudio.component.vc.coreide",
		"microsoft.visualstudio.component.vc.cmake.project"
	]
}
```

Some apps may have higher requirements while liblsl works on very old
(e.g. Windows XP) and tiny (e.g. Raspberry Pi, some microcontrollers, Android)
systems. See the respective build documentation for more information.

## [CMake](https://cmake.org/download/)

The oldest supported version is CMake 3.5.

- *Windows*: choose the installer (.msi extension). During installation, check the box to add it to
  the path (for all users).
- Debian / Ubuntu: `apt install cmake`
- OS X: `brew install cmake`

## [Boost](https://boost.org)

[`liblsl`](https://github.com/labstreaminglayer/liblsl/) already includes Boost,
so you only need it to build some apps.

Boost libraries come in two flavors: header-only and compiled libraries.
For the header-only libraries you can download the source archive and point CMake to it
(`-DBOOST_ROOT=path/to/boost`). For compiled libraries, you either have to compile it yourself
(not recommended) or download precompiled binaries
*that have to match your compiler version and processor architecture!*

Each apps build instructions should tell you exactly which boost libraries you need.

- Windows: install the [precompiled binaries](https://sourceforge.net/projects/boost/files/boost-binaries/)
  - Choose the version that matches your compiler and target architecture (probably 64-bit).
  You can find the mapping between visual studio number and compiler version [here](https://en.wikipedia.org/wiki/Microsoft_Visual_C%2B%2B#Internal_version_numbering).
- Debian / Ubuntu Linux: install the `libboost-all-dev` package
- OS X: install Boost via [Homebrew](https://brew.sh/)

### If your Boost version is so new that cmake can't find it.

CMake has built in instructions on how to find modules and their dependencies within the boost library.
These instructions are tied to specific versions of boost.
If a new version of boost is released, then older cmake will not have instructions on how
to load its modules.
The easiest way to fix this is to use the last version of boost that is compatible with the most
recent version of cmake.
At the time of this writing, CMake 3.10 supported up to Boost 1.65.1

#### MacOS

If you are using MacOS and homebrew, then install an old version of boost with (e.g.)
`brew install boost@1.60`.
Then the cmake argment will be `-DBOOST_ROOT=$(brew --prefix boost@1.60)`.
Try `brew search boost` to see which older versions of boost are available.

#### Using the latest version of boost anyway

If you absolutely need the latest version of boost then the next easiest way to fix this for
this project and other projects, is to edit the file that tells cmake about boost versions:
`C:\Program Files\CMake\share\cmake-3.10\Modules\FindBoost.cmake`.
Scroll down to the section that checks boost versions
(search for `if(NOT Boost_VERSION VERSION_LESS`).
In the last version check check in this section, the one with `set(_Boost_IMPORTED_TARGETS FALSE)`,
modify the `if(NOT Boost_VERSION VERSION_LESS <value>)` to be something greater than your boost version.
e.g., If your boost version is 1.66 then make it `106700`.

NOTE: This has worked for me in the past but IS NOT working for Boost 1.66. Something must have changed.

## [Qt5](http://qt.io)

For compatibility with Ubuntu 16.04, Qt5.5 is the oldest supported version.

Qt5 is the recommended toolkit to create graphical user interfaces.
To build apps using Qt, install it and tell CMake where to find it, either by
adding the compiler specific base path to the PATH
(`set PATH=C:\Qt\<version>\<compiler_arch>;%PATH%` on the same command line you
call cmake from) or add the path to the Qt5 CMake configuration to the cmake parameters
(`-DQt5_DIR=C:/path_to/Qt/<version>/<compiler_arch>/lib/cmake/Qt5/`)

- Windows: use the [installer](http://download.qt.io/official_releases/online_installers/qt-unified-windows-x86-online.exe)
- Debian / Ubuntu Linux: `apt install qt5-default`
- OS X: `brew install qt`
  - it may be necessary to run the following from the project root: `sudo bash ./fix_mac.sh`
