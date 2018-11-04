# Building LSL

This manual describes the process of building liblsl and applications from source for Windows, Mac OS X, and Linux.
Since liblsl is cross-platform (it is written in standard C++ and uses some boost libraries),
this process should be pretty straightforward.
The following paragraphs provide a step-by-step instruction of the build process on all three platforms. 

## Project Structure

This repository contains only the general project structure and references
("[git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)")
to the liblsl C/C++ library
([`LSL/liblsl/`](https://github.com/labstreaminglayer/liblsl/)),
various language bindings (e.g.
[`LSL/liblsl-Python`](https://github.com/labstreaminglayer/liblsl-Python)),
the Apps to stream data from several types of devices including template Examples, and the
[LabRecorder](`https://github.com/labstreaminglayer/App-LabRecorder`).:

```bash
  labstreaminglayer
  ├── Apps
  │   ├── AMTI ForcePlate
  │   ├── Examples
  │   ├── LabRecorder
  │   ├── [several other apps]
  │   └── Wiimote
  └── LSL
    ├── liblsl
    │   ├── external
    │   ├── include
    │   ├── lslboost
    │   ├── project
    │   ├── src
    │   └── testing
    ├── liblsl-Matlab
    ├── liblsl-Python
    └── liblsl-Java
```

To get the project with Git (see also
[Cloning submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules#_cloning_submodules))
either clone the whole repository with submodules
(`git clone --recurse-submodules https://github.com/labstreaminglayer/labstreaminglayer.git`)
or change to the submodules you want to check out after cloning it without
submodules (`git clone https://github.com/labstreaminglayer/labstreaminglayer.git`) and running
in each directory `git submodule init` and `git submodule update`.

## Dependencies (optional)

The core liblsl does not have any external dependencies.
Different language bindings or apps have their own dependencies so please consult those projects' build instructions.

Many apps depend on Qt and boost so we provide some quick instructions here,
but this may not be necessary for you depending on what you are building.

* Windows:
    * [CMake](https://cmake.org/download/)
    * [Qt5](https://www.qt.io/download-open-source/)
    * [Boost](https://sourceforge.net/projects/boost/files/boost-binaries/). Be sure to choose the version that matches your version of MSVC.
* Mac - Use [homebrew](https://brew.sh/)
    * `brew install cmake qt boost`
* Ubuntu (/Debian)
    * `sudo apt-get install build-essential cmake qt5-default libboost-all-dev`

## Build instructions

First, set up your [build environment](BUILD-ENVIRONMENT.md).

There are three build types:

1. [in tree builds](#in-tree-builds-recommended) build the LSL library and all apps you explicitly enable.
   This is probably what you want.
2. [out of tree builds](#out-of-tree-builds) build only a single app and require you to have a
   prebuilt LSL library and the exported build configuration (`LSLConfig.cmake`).
3. [semi out of tree builds](#semi-out-of-tree-builds) build only a single app and liblsl alongside
   it.

### In tree builds (recommended)

1. clone the repository (`git clone --recurse-submodules https://github.com/labstreaminglayer/labstreaminglayer.git`)
1. Create the build directory
  - You can use a GUI file manager to do this part or you can do it by command line as below.
  - Open a terminal/shell/command prompt and change to the labstreaminglayer directory.
      - If the build directory is already there then delete it
          - Windows: `rmdir /S build`; Others: `rm -Rf build`
      - Create the 'build' dir: `mkdir build`
1. Configure the project using cmake
  - Option 1 - Using the GUI
    - Open a terminal/shell/command prompt and change to the labstreaminglayer directory.
      - If you have previously deleted the 'build' dir: `mkdir build`
      - `cd build`
      - `cmake-gui ..` (GUI) or `ccmake ..` (terminal) on other platforms.
    - Do an initial `Configure`. Agree to create the directory if asked.
    - Select your compiler and click Finish.
    - Use the interface to enable building of the Apps you want to use.
    - If necessary, change options or add options/paths (`Add Entry`).
      - [Qt](BUILD-ENVIRONMENT.md#Qt5) if the guessed path is not right
      - [Boost](BUILD-ENVIRONMENT.md#Boost) if the default was not correct
      - A path where redistributable binaries get copied (`CMAKE_INSTALL_PREFIX`)
      - Build type (`CMAKE_BUILD_TYPE`, either `Release` or `Debug`).
        You can change this in Visual Studio later.
      - Click on `Configure` again to confirm changes.
    - Click on `Generate` to create the build files / Visual Studio Solution file
  - Option 2 - Using commandline.
    - Open a Terminal window or, on Windows, a 'Developer Command Prompt for VS2015' (or 2017, as needed)
    - Run cmake with appropriate [commandline options](#common-cmake-options).
  - Option 3 - Visual Studio 2017 or later
    - Open the `CMakeLists.txt` file in Visual Studio (`File`->`Open`->`CMake`)
    - Change CMake settings via `CMake`->`Change CMake Settings`
      - See [Common Cmake Settings](#common-cmake-options) below
    - Change the selected project from the drop-down menu (x64-Debug, x64-Release). This will trigger a CMake re-configure with the new variables.
    
1. Build the project
  - If in MSVC using cmake to generate project files
    - Still in cmake-gui, Click `Open Project`, or if not still in cmake-gui, double click on the
    created build/LabStreamingLayer.sln
    - Change the target to Release.
    - In the solution explorer, right click on INSTALL and click build.
  - If using command line
    - Start the build process (`cmake --build . --config Release --target install`[*](#regarding-the-install-target))
  - If using Visual Studio 2017 built-in CMake utilities
    - Use the CMake menu > Install > LabStreamingLayer

This will create a distribution tree in the folder specified by `CMAKE_INSTALL_PREFIX`[*](#regarding-the-install-target) similar to this:

### 'installed' directory tree

```bash
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
```

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

Building the LSL library should take only 1-2 minutes, so you should prefer
[in tree builds](#in-tree-builds-recommended) unless you know what you're doing.

The process for building liblsl and each app separately is almost exactly as
for [in tree builds](#in-tree-builds-recommended).
The only difference is that you need to `cd` to each submodule separately,
create a build directory (`mkdir build`) and build liblsl / the app as
described above.

### Semi out of tree builds

Semi out of tree builds build only a single app, but liblsl doesn't have to be precompiled
because the liblsl source directory is included as a build target.
These builds are preferable if you need to change / debug both the app and liblsl, but
because compiling liblsl takes considerably longer than most apps you shouldn't do it for more
than one app (see [in tree builds](#in-tree-builds-recommended) for that).

## Common CMake Options

The cmake build system has many options.
If you are using the CMake GUI then these options will be presented to you before you generate the project/makefiles.

If you are using the commandline then default options will generate makefiles for liblsl only.
If you want to use the commandline to generate a project for an IDE, or to generate a project that builds LSL Apps,
then you will have to provide some optional arguments to the cmake command.

- [Generator](https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html#cmake-generators): `-G <generator name>`.
- Apps: `-DLSLAPPS_<AppName>=ON`.
    - `-DLSLAPPS_LabRecorder=ON`
    - `-DLSLAPPS_XDFBrowser=ON`
    - `-DLSLAPPS_OpenVR=ON`
    - TODO: Each app should have its cmake option easily accessible in its readme.
    - TODO: Each app should have its own additional options specified in its readme.
- App dependencies (required by some apps). See [build environment docs](BUILD-ENVIRONMENT.md) for more info.
    - `-DQt5_DIR=<path/to/qt/binaries>/lib/cmake/Qt5`
    - `-DBOOST_ROOT=<path/to/boost>`
        - liblsl comes with its own boost used by itself, but it is not uncommon for apps to require 'normal' boost.
- Install root ([see below](#LSL_INSTALL_ROOT))
    - Not necessary for in-tree builds.

Here are some example cmake commands:

- Chad's Windows build: `cmake .. -G "Visual Studio 14 2015 Win64" -DLSL_LSLBOOST_PATH="lslboost" -DQt5_DIR=C:\Qt\5.11.1\msvc2015_64\lib\cmake\Qt5 -DBOOST_ROOT=C:\local\boost_1_67_0 -DLSLAPPS_LabRecorder=ON -DLSLAPPS_XDFBrowser=ON -DLSLAPPS_OpenVR=ON`
- Chad's Mac build: `cmake .. -DLSL_LSLBOOST_PATH="lslboost" -DLSLAPPS_Examples=ON -DLSLAPPS_LabRecorder=ON -DLSLAPPS_Benchmarks=ON -DLSLAPPS_XDFBrowser=ON -DQt5_DIR=$(brew --prefix qt)/lib/cmake/Qt5/`

### Configure CMake options in VS 2017

If you are using Visual Studio 2017's built-in CMake Tools then the default options would have been used to configure the project.
To set any variables you have to edit a file. Use the CMake menu > Change CMake Settings > LabStreamingLayer.
This will open a json file. For each configuration of interest, add a 'variables' entry with a list of key/value pairs.
For example, under `"name": "x64-Release",` and immediately after `"ctestCommandArgs": ""` add the following:
```
,
      "variables": [
        {
          "name": "Qt5_DIR",
          "value": "C:\\Qt\\5.11.1\\msvc2015_64\\lib\\cmake\\Qt5 "
        },
        {
          "name": "BOOST_ROOT",
          "value": "C:\\local\\boost_1_67_0"
        },
        {
          "name": "LSLAPPS_Examples",
          "value": "ON"
        },
        {
          "name": "LSLAPPS_LabRecorder",
          "value": "ON"
        },
        {
          "name": "LSLAPPS_Benchmarks",
          "value": "ON"
        },
        {
          "name": "LSLAPPS_XDFBrowser",
          "value": "ON"
        }
      ]
```

### `LSL_INSTALL_ROOT`

To import the LSL library in a separate CMake build, you need to set the the
**absolute path** to the ['installed' LSL directory](#install-directory-tree)
in the `LSL_INSTALL_ROOT` variable (e.g. `-DLSL_INSTALL_ROOT=C:/LSL/build/install/`)
or add the **absolute path** to the`LSL/cmake` subfolder
of the ['installed' LSL directory](#install-directory-tree) to your `CMAKE_PREFIX_PATH`
(`list(APPEND CMAKE_MODULE_PATH "C:/path/to/LSL/build/install/cmake/")`.

CMake looks for the file `${LSL_INSTALL_ROOT}/LSL/share/LSL/LSLConfig.cmake`,
so make sure your `LSL_INSTALL_ROOT` has the files listed in
[the previous section](#installed-directory-tree).

By default, apps should look in `../../LSL/liblsl/build/install` so if you
have a `build` folder in each submodule (`LSL/liblsl/build`,
`Apps/Examples/build` etc.) and installed `liblsl` first, CMake automatically
finds liblsl.

## Building for multiple platforms

In case you haven't got several PCs and Macs with different build environments
to test your changes, you can use the [CI](CIs.md) to compile the code on
multiple platforms and offer binaries to willing testers.

### Note about architectures / binaries

(Also known as: "Which `liblsl.so` / `liblsl.dll` do I need?)

Liblsl gets compiled to a binary for a combination of
Operating System / libc (almost almost the same) and processor architecture.

Most binaries include the native word size in bits in the name and a hint which
platform the binary is for in the file extension,
e.g. liblsl*32*.dll for a 32-bit windows dll, liblsl*64*.so for a 64 bit
Linux / Android library or liblsl64.dylib for a 64 bit OS X dylib.

The CI system automatically builds the following combinations:

- x86 Windows DLL (liblsl32.dll)
- x64 Windows DLL (liblsl64.dll)
- x64 Linux shared object (liblsl64.so)
- x64 OS X shared object (liblsl64.dylib)

Android also has `.so` shared objects, but build with a different
toolchain so they are not interchangable with `.so` files for regular Linuxes.
It's planned to build Android binaries for the following architectures on the
CI systems: arm64-v8a, armeabi, mips64, x86_64.


### Raspberry Pi (cross-compilation, currently not working)

Intended for Ubuntu 18.04

* In terminal, cd to a working folder.
* `git clone https://github.com/raspberrypi/tools.git`
* `export PITOOLS=/path/to/raspberrypi/tools`
* Change to labstreaminglayer directory
* `mkdir build_pi && cd build_pi`
* `cmake .. -DLSL_LSLBOOST_PATH="lslboost" -DCMAKE_TOOLCHAIN_FILE=../LSL/liblsl/pi.cmake`
* `make`

### Raspberry Pi (native Raspbian)

Just follow the usual [build instructions](#build-instructions).

Some caveats:

- Make sure your charger is appropriate (>2.5A@5V for the 3B+),
  otherwise the build will hang or your Pi will reset.
- Avoid building with a running GUI, minimize the GPU memory 
  (option `gpu_mem` in `/boot/config.txt`) and have at most 2 build processes
  running at once (`-j` option to make / ninja).

