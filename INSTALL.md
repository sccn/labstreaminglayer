# General

This manual describes the process of building liblsl from source for Windows, Mac OS X, and Linux.
Since liblsl is cross-platform (it is written in standard C++ and uses some boost libraries),
this process should be pretty straightforward.
The following paragraphs provide a step-by-step instruction of the build process on all three platforms. 

To get an overview of the project structure, the following tree lists the directory
hierarchy of the source after you've unpacked the compressed source archive:

    labstreaminglayer
    ├── Apps
    │   ├── AMTI ForcePlate
    │   ├── Examples
    │   ├── [several other apps]
    │   └── Wiimote
    └── LSL
        ├── liblsl
        │   ├── bin
        │   ├── examples
        │   ├── external
        │   │   ├── lslboost
        │   │   └── src
        │   ├── include
        │   ├── project
        │   ├── src
        │   │   ├── portable_archive
        │   │   └── pugixml
        │   └── testing
        ├── liblsl-Matlab
        ├── liblsl-Python
        └── liblsl-Java

LSL and some Apps are built with CMake, the remaining Apps use Visual Studio Solution files.

# Configure with CMake

## Toolchain

Download a toolchain. The following platforms have been tested:

* Windows 7, Windows 10
    * [Visual Studio 2015](https://www.visualstudio.com/vs/older-downloads/) ([alternate](https://stackoverflow.com/a/44290942)), or [Visual Studio 2017](https://www.visualstudio.com/downloads/). During install, choose custom install and be sure to select under programming languages > Visual C++ > Common Tools (this should add the Windows SDK to the installation).
* Ubuntu Linux 14.04, 16.04
    * Clang 3.5
    * GCC 6.2
* MacOS Sierra
    * XCode 8.3

## Prerequisites

To build LSL only, using the version of boost that comes with LSL, all you need is cmake.

* [CMake](https://cmake.org/download/)
    * On Windows, choose the installer (.msi extension). During installation, check the box to add it to the path (for all users).

To build many of the Apps, you may need Boost and/or Qt:

* [Boost](https://boost.org) (+path set with `-DBOOST_ROOT=path/to/boost`)
    - Windows: install the [precompiled binaries](https://sourceforge.net/projects/boost/files/boost-binaries/)
        - Choose the version that matches your compiler and target architecture (probably 64-bit). You can find the mapping between visual studio number and compiler version [here](https://en.wikipedia.org/wiki/Microsoft_Visual_C%2B%2B#Internal_version_numbering). 
    - Debian / Ubuntu Linux: install the `libboost-dev` package
    - OS X: install Boost via [Homebrew](https://brew.sh/)
* [Qt](http://qt.io) (+path set with `-DQt5_DIR=C:/path_to/Qt/<version>/<compiler_arch>/lib/cmake/Qt5/` or `set PATH=C:\Qt\<version>\<compiler_arch>;%PATH%`)
    - Windows: use the [installer](http://download.qt.io/official_releases/online_installers/qt-unified-windows-x86-online.exe)
    - Debian / Ubuntu Linux: install the `qtbase5-dev` package

On Mac, if using homebrew Qt5, it is necessary to run the following from the project root:
`sudo bash ./fix_mac.sh`

# Build instructions

There are two build types:

1. [in tree builds](#in-tree-builds-recommended) build the LSL library and all apps you explicitely enable. This is probably what you want.
1. [out of tree builds](#out-of-tree-builds) build only a single app and require you to have a prebuilt LSL library and the exported build configuration (`LSLConfig.cmake`).

## In tree builds (recommended)

1. extract the zip file or clone the repository (`git clone https://github.com/sccn/labstreaminglayer.git`)
2. Configure the project using cmake
    * Option 1 - Using the GUI
        - Windows only:
            - Start `build_windows.bat` then press any key after reading the instructions.
            - If the source code field is empty then click on `Browse Source`. The default folder should be correct (i.e., the one containing build_windows.bat)
        - Others:
            - Open a terminal/shell/command prompt and change to the labstreaminglayer directory.
            - If you have previously deleted the 'build' dir: `mkdir build`
            - `cd build`
            - `cmake-gui ..` on Windows or `ccmake ..` on other platforms.
        - Do an initial `Configure`. Agree to create the directory if asked.
        - Select your compiler and click Finish.
        - Use the interface to enable building of the Apps you want to use.
        - If necessary, change options or add options/paths (`Add Entry`).
            - Location of Qt5Config.cmake if the default was not correct (`Qt5_DIR`, PATH, e.g. `C:/Qt/5.10.0/msvc2015_64/lib/cmake/Qt5/`)
            - Boost if the default was not correct (`BOOST_ROOT`, PATH, e.g. `C:/local/boost_1_65_1/`)
            - A path where redistributable binaries get copied (`CMAKE_INSTALL_PREFIX`)
            - Build type (`CMAKE_BUILD_TYPE`, either `Release` or `Debug`). You can change this in Visual Studio later.
            - Click on `Configure` again to confirm changes.
        - Click on `Generate` to create the build files / Visual Studio Solution file
    * Option 2 - Using commandline.
        - Open a Terminal window or a 'Developer Command Prompt for VS2015' (or 2017, as needed)
        - Run cmake with commandline options.  The following is an example. Add/remove/modify options as required:
            - `cmake .. -G "Visual Studio 14 2015 Win64" -DQt5_DIR=C:\Qt\5.10.0\msvc2015_64\lib\cmake\Qt5 -DBOOST_ROOT=C:\local\boost_1_65_1 -DLSLAPPS_LabRecorder=ON -DLSLAPPS_XDFBrowser=ON -DLSLAPPS_OpenVR=ON`
3. Build the project
    * Option 1 - Using MSVC
        - Still in cmake-gui, Click `Open Project`, or if not still in cmake-gui, double click on the created build/LabStreamingLayer.sln
        - Change the target to Release.
        - In the solution explorer, right click on INSTALL and click build.
    * Option 2 - command line
        - Start the build process (`cmake --build . --config Release --target install`[*](#regarding-the-install-target))

This will create a distribution tree in the folder specified by `CMAKE_INSTALL_PREFIX`[*](#regarding-the-install-target) similar to this:

## 'installed' directory tree

    ├── AppX
    │   ├── AppX.exe
    │   ├── liblsl64.dll
    │   ├── Qt5Xml.dll
    │   ├── Qt5Gui.dll
    │   └── AppX_configuration.ini
    ├── AppY
    │   ├── AppY.exe
    │   ├── AppY_conf.exe
    │   ├── liblsl64.dll
    │   └── example.png
    ├── examples
    │   ├── CppReceive.exe
    │   ├── CppSendRand.exe
    │   ├── SendDataC.exe
    │   ├── liblsl64.dll
    └── LSL
        ├── cmake
        │   ├── LSLAppBoilerplate.cmake
        │   ├── LSLConfig.cmake
        │   └── [snip]
        ├── include
        │   ├── lsl_c.h
        │   └── lsl_cpp.h
        └── lib
            ├── liblsl64.dll
            ├── liblsl64.lib
            └── lslboost.lib

On Unix systems (Linux+OS X) the executable's library path is changed to include
`../LSL/lib/` and the executable folder (`./`) so common libraries (Qt, Boost)
can be distributed in a single library directory or put in the same folder.
On Windows, the library is copied to (and searched in) the executable folder.

The resulting folder `LSL` contains three subfolders:

* `cmake` contains the exported build configuration (`LSLConfig.cmake`) that can be used to import the library in [out of tree builds](#out-of-tree-builds).
* `include` contains the include headers for C (`lsl_c.h`) and C++ (`lsl_cpp.h`) programs.
* `lib` contains the library files. To run a program, you need the `liblslXY.dll` (Windows) or `.so` (Linux) or `.dylib` (MacOS).

## Regarding the `install` target

CMake places built binary files as well as build sideproducts in a build tree that should be separate from
the source directory. To copy only the needed files (and additional library files they depend on) to a folder
you can share with colleagues or onto another PC, you need to 'install' them.
This doesn't mean 'installing' them in a traditional sense (i.e., with Windows installers or package managers on
Linux / OS X), but only copying them to a separate folder and fixing some hardcoded paths in the binaries.

## Out of tree builds

An out of tree build doesn't include the whole `labstreaminglayer` directory but only a single application
(a minimal example is contained in the folder `OutOfTreeTest`).

Building the LSL library should take only 1-2 minutes, so you should prefer [in tree builds](#in-tree-builds-recommended)
unless you know what you're doing.

To import the LSL library in a separate CMake build, you need to set the the 
**absolute path** to the['installed' LSL directory](#install-directory-tree)
in the `LSL_INSTALL_ROOT` variable (e.g. `-DLSL_INSTALL_ROOT=C:/LSL/build/install/lsl_Release/LSL`) or add the **absolute path** to the`LSL/cmake` subfolder
of the ['installed' LSL directory](#install-directory-tree) to your `CMAKE_PREFIX_PATH`
(`list(APPEND CMAKE_MODULE_PATH "C:/path/to/LSL/build/install/cmake/")`.

## Troubleshooting

### If your Boost version is so new that cmake can't find it.

CMake has built in instructions on how to find modules and their dependencies within the boost library.
These instructions are tied to specific versions of boost.
If a new version of boost is released, then older cmake will not have instructions on how to load its modules.
The easiest way to fix this is to use the last version of boost that is compatible with the most recent version of cmake.
At the time of this writing, CMake 3.10 supported up to Boost 1.65.1

#### MacOS

If you are using MacOS and homebrew, then install an old version of boost with (e.g.) `brew install boost@1.60`. Then the cmake argment will be `-DBOOST_ROOT=$(brew --prefix boost@1.60)`. Try `brew search boost` to see which older versions of boost are available.

#### Using the latest version of boost anyway

If you absolutely need the latest version of boost then the next easiest way to fix this for this project and other projects,
is to edit the file that tells cmake about boost versions:
`C:\Program Files\CMake\share\cmake-3.10\Modules\FindBoost.cmake`.
Scroll down to the section that checks boost versions (search for `if(NOT Boost_VERSION VERSION_LESS `).
In the last version check check in this section, the one with `set(_Boost_IMPORTED_TARGETS FALSE)`,
modify the `if(NOT Boost_VERSION VERSION_LESS <value>)` to be something greater than your boost version.
e.g., If your boost version is 1.66 then make it `106700`.

NOTE: This has worked for me in the past but IS NOT working for Boost 1.66. Something must have changed.
