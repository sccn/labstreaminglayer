Library Development
###################

.. note:: Stop reading if you just want to...

  - stream data from one of the :doc:`../info/supported_devices` or record data with the
    LabRecorder. You can download pre-built releases for the apps and LabRecorder from each
    repositories release page.

  - create or use a program to stream or receive data via the LabStreamingLayer. You can
    download a liblsl release following instructions on the 
    `liblsl repository <https://github.com/sccn/liblsl/>`_

Follow this guide if you...

- want to add / modify core liblsl

  - Please create a `GitHub issue <https://github.com/sccn/liblsl/issues>`__
    first to ask for advice and to get pre-approval if you would like your
    modification to be included in the official library.

- want to build liblsl for a device / OS with no official release (e.g. an embedded Linux device)

.. _build_liblsl:

Building liblsl
***************

Before attempting to build liblsl, please make sure you have configured your :doc:`build_env`.

This part of the guide describes the process of building liblsl from source
for Windows, Mac OS, and Linux. Since liblsl is cross-platform (it is written
in standard C++ and its dependencies are all cross-platform), this process should be pretty
straightforward. The following paragraphs provide a step-by-step instruction of
the build process on all three platforms.

Getting the source
==================

Open a Terminal / Developer Command Prompt and cd to a convenient location to download and build the library.

:samp:`git clone --depth=1 https://github.com/sccn/liblsl.git`

The resulting folder structure is as follows.

.. code:: bash

     (working directory)
     └── liblsl
         ├── {...}
         ├── include
         ├── lslboost
         ├── project
         ├── src
         └── testing

Configuring the liblsl project
==============================

.. note::
    Most popular IDEs have integrated CMake support. Typically, all that is necessary is to open
    the root liblsl folder (i.e., the folder containing :file:`CMakeLists.txt`) and select the 
    appropriate CMake options in the IDE.
    If you wish to use the IDE's integrated cmake, then you do not need to follow the
    terminal commands below.

.. code:: bash

    cd liblsl
    cmake -S . -B build -G <generator name> <other options>

Note: call :samp:`cmake -G` without a generator name to get a list of available
generators.
I have used :samp:`cmake -S . -B build -G "Visual Studio 16 2019" -A x64 -DCMAKE_INSTALL_PREFIX="build/install"`

If you used a generator, you can now open the IDE project file. Then build the install target.

Alternatively, you can build directly from command line:
:samp:`cmake --build build -j --config Release --target install`

In either case, this will create an ``install`` folder in your build folder.
This ``install`` folder is your :doc:`LSL_INSTALL_ROOT` that you might use in when 
:doc:`building other applications.<app_dev>`

Build options for liblsl
************************

There are several liblsl-specific build options.
All of them can be set either in the GUI (cmake-gui or IDE) or on the
command line (:samp:`cmake -D{foo}={bar}`).

.. option:: CMAKE_INSTALL_PREFIX

  This is not an LSL-provided option, but it's a common and important option when building the install target.
  See the `official documentation <https://cmake.org/cmake/help/latest/variable/CMAKE_INSTALL_PREFIX.html>`_.
  This argument is often necessary on Windows because otherwise it will attempt to install into C:\Program Files
  which will fail without administrative rights. A good value to pass is "build/install".

.. option:: LSL_DEBUGLOG

   Enable (lots of) additional debug messages. Defaults to OFF.

.. option:: LSL_BUILD_EXAMPLES

  The liblsl distributions includes several example programs.
  Enabling this option builds them alongside liblsl.

.. option:: LSL_BUILD_STATIC

  By default, a shared library (`.so` on Unix, `.dylib` on OS X and `.dll` on
  Windows) is built. This also exports a static library.

.. option:: LSL_LEGACY_CPP_ABI

  Once upon a time there was a C++-ABI, but it only worked under very specific
  circumstances and created hard to debug errors otherwise. Don't enable this
  unless you know exactly what you are doing.

.. option:: LSL_FORCE_FANCY_LIBNAME

  By default, CMake decides what to name the library (see :ref:`liblslarch`).
  On Windows this is :file:`lsl.{<extension>}` 
  and for Unix (Linux/Mac) it is :file:`liblsl.{<extension>}`.
  Enabling this option will force the library to be named
  :file:`liblsl{<ptrsize>}.{<extension>}`
  on all platforms.

.. option:: LSL_UNITTESTS

   liblsl includes two types of unittests: internal tests, that check that
   various internal components work as intended, and external tests that
   test the API as programs would.

.. option:: LSL_UNIXFOLDERS

  Macs, Unix / Android systems and distributions like Anaconda have a specific
  directory layout (binaries in :file:`{prefix}/bin`, includes in
  :file:`{prefix}/include` and so on), whereas Windows users prefer
  everything in a single folder.
  If enabled, the :doc:`LSL_INSTALL_ROOT` folder will have a layout as it
  should be on Unix systems.

.. option:: LSL_WINVER

  Change the minimum targeted Windows version, defaults to `0x0601` for
  Windows 7.
  
.. option:: LSL_OPTIMIZATIONS

  Enable some more compiler optimizations. Defaults to ON.

.. option:: LSL_BUNDLED_PUGIXML

  Use the bundled pugixml by default. Defaults to ON.

Modifying liblsl
****************

First read :doc:`the introduction </info/intro>` to learn about LSL components and classes.
:doc:`The C++ API documentation <liblsl:index>` is a work-in-progress but might also be a good reference.

Updating Boost
**************

liblsl uses boost.
Because embedding liblsl in an application that links to an other Boost version (notably Matlab)
causes runtime errors, we bundle a subset of boost in
`lslboost`.

To update the included lslboost, install Boost bcp and use the `update_lslboost.sh` script.

Building liblsl language bindings
*********************************

The most notable language bindings are `pylsl (Python) <https://github.com/labstreaminglayer/pylsl>`_ and `liblsl-Matlab <https://github.com/labstreaminglayer/liblsl-Matlab>`_. See their respective pages for building guides.

See also the repositories for `CSharp <https://github.com/labstreaminglayer/liblsl-Csharp>`_, `Unity Custom Package <https://github.com/labstreaminglayer/LSL4Unity>`_, `Rust <https://github.com/labstreaminglayer/liblsl-rust>`_, `Java <https://github.com/labstreaminglayer/liblsl-Java>`_, and `Julia (external) <https://github.com/samuelpowell/LSL.jl>`_.

Full Tree Dev
*************

For advanced users (mostly core developers), it might be useful to simultaneously develop multiple apps and/or libraries. For this, please see the :doc:`full_tree` documentation to setup the lib and app tree,
then follow the build instructions in :doc:`build_full_tree`.

Maintaining package manager ports
*********************************

Ports of liblsl are available via a number of third-party package managers.
When new releases of liblsl are published,
these ports can be updated using the following steps:

vcpkg
=====

vcpkg ports are managed in the `microsoft/vcpkg <https://github.com/microsoft/vcpkg>`_ repository on GitHub
and changes or additions are submitted in the form of pull requests.
For a general overview of vcpkg, see https://github.com/microsoft/vcpkg/tree/master/docs.

The liblsl port is maintained at https://github.com/microsoft/vcpkg/tree/master/ports/liblsl.

- For new liblsl releases where no changes have been made in the CMake build scripts,
  it should be enough to update the library versions in `vcpkg.json <https://github.com/microsoft/vcpkg/blob/master/ports/liblsl/vcpkg.json>`_
  and in `portfile.cmake <https://github.com/microsoft/vcpkg/blob/master/ports/liblsl/portfile.cmake>`_.

- If there have been changes in the CMake build scripts, portfile.cmake may need to be adapted accordingly.
  If any dependencies have changed (e.g. the version of Boost), the dependency information in vcpkg.json needs to be updated, as well.

Conan
=====

Conan packages are managed in the `conan-io/conan-center-index <https://github.com/conan-io/conan-center-index>`_ repository on GitHub
and changes or additions are submitted in the form of pull requests.
For a general overview of the Conan package maintenance process, see `Adding Packages to ConanCenter <https://github.com/conan-io/conan-center-index/blob/master/docs/how_to_add_packages.md>`_.

The liblsl port is maintained at https://github.com/conan-io/conan-center-index/tree/master/recipes/liblsl.

- For new liblsl releases where no changes have been made in the CMake build scripts, 
  it should be enough to add the new library version to `config.yml <https://github.com/conan-io/conan-center-index/blob/master/recipes/liblsl/config.yml>`_
  and to `conandata.yml <https://github.com/conan-io/conan-center-index/blob/master/recipes/liblsl/all/conandata.yml>`_.

- If there have been changes in the CMake build scripts, `conanfile.py <https://github.com/conan-io/conan-center-index/blob/master/recipes/liblsl/all/conanfile.py>`_ may need to be adapted accordingly.
  If any dependencies have changed (e.g. the version of Boost), the dependency information in conanfile.py needs to be updated, as well.

homebrew
========

No documentation yet.
See https://github.com/labstreaminglayer/homebrew-tap
