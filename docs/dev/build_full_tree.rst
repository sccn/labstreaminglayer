:orphan:

.. role:: cmd(code)
   :language: bash

Building LabStreamingLayer Full Tree
====================================

This guide is intended only for advanced developers who intend to work
 on multiple projects and/or the core library simultaneously.

Project Structure
-----------------

This main `labstreaminglayer repository <https://github.com/sccn/labstreaminglayer>`__
contains only the general project structure and references (“`git
submodules <https://git-scm.com/book/en/v2/Git-Tools-Submodules>`__”) to
the liblsl C/C++ library
(`LSL/liblsl <https://github.com/labstreaminglayer/liblsl/>`__),
various language bindings (e.g.
`LSL/liblsl-Python <https://github.com/labstreaminglayer/liblsl-Python>`__),
the Apps to stream data from several types of devices
including a template examples, and the
`LabRecorder <https://github.com/labstreaminglayer/App-LabRecorder>`__.:

.. code:: bash

     labstreaminglayer
     ├── Apps
     │   ├── AMTI ForcePlate
     │   ├── LabRecorder
     │   ├── [several other apps]
     │   └── Wiimote
     └── LSL
       ├── liblsl
       │   ├── include
       │   ├── lslboost
       │   ├── project
       │   ├── src
       │   └── testing
       ├── liblsl-Matlab
       ├── liblsl-Python
       └── liblsl-Java

To get the project source code using Git, see :doc:`full_tree`.


Dependencies (optional)
-----------------------

The core ``liblsl`` does not have any external dependencies.

Different language bindings or apps have their own dependencies so
please consult those projects’ build instructions.

Many apps depend on :ref:`Qt5`, :ref:`boost`, and many use :ref:`CMake` build system.
Follow the instructions to set up your :doc:`build_env`.

Build instructions
------------------

In tree builds (recommended)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Create the build directory

-  You can use a GUI file manager to do this part or you can do it by
   command line as below.
-  Open a Terminal/shell/Command Prompt and change to the
   labstreaminglayer directory.

   -  If the build directory is already there then delete it

      -  Windows: :cmd:`rmdir /S build`; Others: :cmd:`rm -Rf build`

1. Configure the project using :ref:`buildenvcmake`

- Option 1 - Visual Studio 2017 or later

   -  Open the :file:`CMakeLists.txt` file in Visual Studio
      (:guilabel:`File->Open->CMake`)
   -  Change CMake settings via :guilabel:`CMake->Change CMake Settings`

      -  See `Common Cmake Settings <#common-cmake-options>`__ below

   -  Change the selected project from the drop-down menu (:guilabel:`x64-Debug`,
      :guilabel:`x64-Release`).
      This will trigger a CMake re-configure with the new variables.

-  Option 2 - Using commandline.

   -  Open a Terminal window or, on Windows, a ‘Developer Command Prompt
      for VS2017’ (or 2019, as needed)
   -  Run cmake with appropriate `commandline options <#common-cmake-options>`__.

-  Option 3 - Using the GUI

   -  Open a terminal/shell/command prompt and change to the
      labstreaminglayer directory (:cmd:`cmake-gui -S . -B build`)
   -  Do an initial :guilabel:`Configure`.
      Agree to create the directory if asked.
   -  Select your compiler and click Finish.
   -  Use the interface to set or add options/paths (:guilabel:`Add Entry`).

      -  :ref:`Qt5` if the guessed path is not right
      -  :ref:`Boost` if the default was not correct
      -  A path where redistributable binaries get copied
         (``CMAKE_INSTALL_PREFIX``)
      -  Build type (``CMAKE_BUILD_TYPE``, either ``Release`` or
         ``Debug``). You can change this in Visual Studio later.
      -  Click on :guilabel:`Configure` again to confirm changes.

   -  Click on :guilabel:`Generate` to create the build files / Visual Studio
      Solution file

2. Build the project
-  If using command line

   -  Start the build process
      (:cmd:`cmake --build . --config Release --target install`
      (see also :ref:`cmakeinstalltarget`)

-  If using Visual Studio 2017 built-in CMake utilities

   -  Use the CMake menu > Install > LabStreamingLayer

This will create a distribution tree in the folder specified by
:ref:`CMAKE_INSTALL_PREFIX <cmakeinstalltarget>` similar to this:

‘installed’ directory tree
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

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
       ├── share
       │   ├── LSL
       │   │   ├── LSLCMake.cmake
       │   │   ├── LSLConfig.cmake
       │   │   └── LSLCMake.cmake
       ├── include
       │   ├── lsl_c.h
       │   └── lsl_cpp.h
       └── lib
         ├── liblsl64.dll
         ├── liblsl64.lib
         └── lslboost.lib

On Unix systems (Linux+OS X) the executable’s library path is changed to
include :file:`../LSL/lib/` and the executable folder (:file:`./`) so common
libraries (Qt, Boost) can be distributed in a single library directory
or put in the same folder.
On Windows, the library is copied to (and searched in) the executable folder.

The resulting folder :file:`LSL` contains three subfolders:

-  :file:`cmake` contains the exported build configuration
   (:file:`LSLConfig.cmake`) that can be used to import the library in `out
   of tree builds <#out-of-tree-builds>`__.
-  :file:`include` contains the include headers for C (:file:`lsl_c.h`) and C++
   (:file:`lsl_cpp.h`) programs.
-  :file:`lib` contains the library files. To run a program, you need the
   :file:`liblslXY.dll` (Windows) or :file:`.so` (Linux) or :file:`.dylib` (MacOS).

.. _cmakeinstalltarget:

Regarding the ``install`` target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CMake places built binary files as well as build sideproducts in a build
tree that should be separate from the source directory. To copy only the
needed files (and additional library files they depend on) to a folder
you can share with colleagues or onto another PC, you need to ‘install’
them. This doesn’t mean ‘installing’ them in a traditional sense (i.e.,
with Windows installers or package managers on Linux / OS X), but only
copying them to a separate folder and fixing some hardcoded paths in the
binaries.

Common CMake Options
--------------------

The cmake build system has many options. If you are using the CMake GUI
then these options will be presented to you before you generate the
project/makefiles.

If you are using the commandline then default options will generate
makefiles for liblsl only. If you want to use the commandline to
generate a project for an IDE, or to generate a project that builds LSL
Apps, then you will have to provide some optional arguments to the cmake
command.

-  `Generator <https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html#cmake-generators>`__:
   ``-G <generator name>``.
-  Apps: ``-DLSLAPPS_<AppName>=ON``.

   -  ``-DLSLAPPS_LabRecorder=ON``
   -  ``-DLSLAPPS_XDFBrowser=ON``
   -  ``-DLSLAPPS_OpenVR=ON``
   -  TODO: Each app should have its cmake option easily accessible in
      its readme.
   -  TODO: Each app should have its own additional options specified in
      its readme.

-  App dependencies (required by some apps). See :ref:`lslbuildenv` for more info.

   -  ``-DQt5_DIR=<path/to/qt/binaries>/lib/cmake/Qt5``
   -  ``-DBOOST_ROOT=<path/to/boost>``

      -  liblsl comes with its own boost used by itself, but it is not
         uncommon for apps to require ‘normal’ boost.

-  Install root (see :doc:`LSL_INSTALL_ROOT`)

   -  Not necessary for in-tree builds.

Here are some example cmake commands:

-  Chad’s Windows build:
   ``cmake .. -G "Visual Studio 14 2015 Win64" -DQt5_DIR=C:\Qt\5.11.1\msvc2015_64\lib\cmake\Qt5 -DBOOST_ROOT=C:\local\boost_1_67_0 -DLSLAPPS_LabRecorder=ON -DLSLAPPS_XDFBrowser=ON -DLSLAPPS_OpenVR=ON``
-  Chad’s Mac build:
   ``cmake .. -DQt5_DIR=$(brew --prefix qt)/lib/cmake/Qt5/ -DLSLAPPS_LabRecorder=ON -DLSLAPPS_Benchmarks=ON -DLSLAPPS_XDFBrowser=ON``

Configure CMake options in VS 2017 / VS 2019
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you are using Visual Studio 2017’s built-in CMake Tools then the
default options would have been used to configure the project. To set
any variables you have to edit a file. Use the CMake menu > Change CMake
Settings > LabStreamingLayer. This will open a json file. For each
configuration of interest, add a ‘variables’ entry with a list of
key/value pairs. For example, under ``"name": "x64-Release",`` and
immediately after ``"ctestCommandArgs": ""`` add the following:

::

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
