# Building LSL

This manual describes the process of building liblsl and applications from source for Windows, Mac OS X, and Linux.
Since liblsl is cross-platform (it is written in standard C++ and uses some boost libraries),
this process should be pretty straightforward.
The following paragraphs provide a step-by-step instruction of the build process on all three platforms. 

## Project Structure

This repository contains only the general project structure and references
("[git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)")
to the liblsl C library
([`LSL/liblsl/`](https://github.com/labstreaminglayer/liblsl/),
the language bindings in the `[LSL](LSL)` subfolder (e.g.
[`LSL/liblsl-Python`](https://github.com/labstreaminglayer/liblsl-Python))
and the Apps to stream data from several types of devices, the
[LabRecorder](`https://github.com/labstreaminglayer/App-LabRecorder`) and
[C / C++ code examples](`https://github.com/labstreaminglayer/App-LabRecorder`)
in the [`Apps`](Apps) subfolder:

  labstreaminglayer
  ├── Apps
  │   ├── AMTI ForcePlate
  │   ├── Examples
  │   ├── LabRecorder
  │   ├── [several other apps]
  │   └── Wiimote
  └── LSL
    ├── liblsl
    │   ├── external
    │   ├── include
    │   ├── lslboost
    │   ├── project
    │   ├── src
    │   └── testing
    ├── liblsl-Matlab
    ├── liblsl-Python
    └── liblsl-Java

To get the project with Git (see also
[Cloning submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules#_cloning_submodules))
either clone the whole repository with submodules
(`git clone --recurse-submodules https://github.com/labstreaminglayer/labstreaminglayer.git )
or change to the submodules you want to check out after cloning it without
submodules (`git clone https://github.com/labstreaminglayer/labstreaminglayer.git`) and running
in each directory `git submodule init` and `git submodule update`.

## Build instructions

First, set up your [build environment](BUILD-ENVIRONMENT.md).

There are two build types:

1. [in tree builds](#in-tree-builds-recommended) build the LSL library and all apps you explicitely enable.
   This is probably what you want.
2. [out of tree builds](#out-of-tree-builds) build only a single app and require you to have a
   prebuilt LSL library and the exported build configuration (`LSLConfig.cmake`).

### In tree builds (recommended)

1. extract the zip file or clone the repository (`git clone --recurse-submodules https://github.com/labstreaminglayer/labstreaminglayer.git`)
2. Configure the project using cmake
  - Option 1 - Using the GUI
    - Open a terminal/shell/command prompt and change to the labstreaminglayer directory.
      - If you have previously deleted the 'build' dir: `mkdir build`
      - `cd build`
      - `cmake-gui ..` (GUI) or `ccmake ..` (terminal) on other platforms.
    - Do an initial `Configure`. Agree to create the directory if asked.
    - Select your compiler and click Finish.
    - Use the interface to enable building of the Apps you want to use.
    - If necessary, change options or add options/paths (`Add Entry`).
      - [Qt](BUILD-ENVIRONMENT.md#Qt5] if the guessed path is not right
      - [Boost](BUILD-ENVIRONMENT.md#Boost] if the default was not correct
      - A path where redistributable binaries get copied (`CMAKE_INSTALL_PREFIX`)
      - Build type (`CMAKE_BUILD_TYPE`, either `Release` or `Debug`).
        You can change this in Visual Studio later.
      - Click on `Configure` again to confirm changes.
    - Click on `Generate` to create the build files / Visual Studio Solution file
  - Option 2 - Using commandline.
    - Open a Terminal window or a 'Developer Command Prompt for VS2015' (or 2017, as needed)
    - Run cmake with commandline options.  The following is an example. Add/remove/modify options
      as required:
      - `cmake .. -G "Visual Studio 14 2015 Win64" -DQt5_DIR=C:\Qt\5.11.1\msvc2015_64\lib\cmake\Qt5 -DBOOST_ROOT=C:\local\boost_1_67_0 -DLSLAPPS_LabRecorder=ON -DLSLAPPS_XDFBrowser=ON -DLSLAPPS_OpenVR=ON`
  - Option 3 - Visual Studio 2017 or later
    - Open the `CMakeLists.txt` file in Visual Studio (`File`->`Open`->`CMake`)
    - Change CMake settings via `CMake`->`Change CMake Settings`
3. Build the project
  - Option 1 - Using MSVC
    - Still in cmake-gui, Click `Open Project`, or if not still in cmake-gui, double click on the
    created build/LabStreamingLayer.sln
    - Change the target to Release.
    - In the solution explorer, right click on INSTALL and click build.
  - Option 2 - command line
    - Start the build process (`cmake --build . --config Release --target install`[*](#regarding-the-install-target))

This will create a distribution tree in the folder specified by `CMAKE_INSTALL_PREFIX`[*](#regarding-the-install-target) similar to this:

### 'installed' directory tree

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
    │   ├── LSLCMake.cmake
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

- `cmake` contains the exported build configuration (`LSLConfig.cmake`) that can be used to import
  the library in [out of tree builds](#out-of-tree-builds).
- `include` contains the include headers for C (`lsl_c.h`) and C++ (`lsl_cpp.h`) programs.
- `lib` contains the library files. To run a program, you need the `liblslXY.dll` (Windows) or `.so` (Linux) or `.dylib` (MacOS).

### Regarding the `install` target

CMake places built binary files as well as build sideproducts in a build tree that should be separate
from the source directory.
To copy only the needed files (and additional library files they depend on) to a folder you can
share with colleagues or onto another PC, you need to 'install' them.
This doesn't mean 'installing' them in a traditional sense (i.e., with Windows installers or package
managers on Linux / OS X), but only copying them to a separate folder and fixing some hardcoded
paths in the binaries.

### Out of tree builds

An out of tree build doesn't include the whole `labstreaminglayer` directory but only a single application
(a minimal example is contained in the
[`OutOfTreeTest`](https://github.com/labstreaminglayer/App-OutOfTreeTest) folder).

Building the LSL library should take only 1-2 minutes, so you should prefer [in tree builds](#in-tree-builds-recommended)
unless you know what you're doing.

To import the LSL library in a separate CMake build, you need to set the the
**absolute path** to the ['installed' LSL directory](#install-directory-tree)
in the `LSL_INSTALL_ROOT` variable (e.g. `-DLSL_INSTALL_ROOT=C:/LSL/build/install/lsl_Release/LSL`)
or add the **absolute path** to the`LSL/cmake` subfolder
of the ['installed' LSL directory](#install-directory-tree) to your `CMAKE_PREFIX_PATH`
(`list(APPEND CMAKE_MODULE_PATH "C:/path/to/LSL/build/install/cmake/")`.
