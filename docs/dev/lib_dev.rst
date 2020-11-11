Library Development
###################

.. note:: Stop reading if you just want to...

  - stream data from one of the :doc:`../info/supported_devices` or record data with the
    LabRecorder. You can download pre-built releases for the apps and LabRecorder from each
    repositories release page.

  - create or use a program to stream or receive data via the LabStreamingLayer. You can
    download a precompiled liblsl binary from the
    `liblsl release page <https://github.com/sccn/liblsl/releases>`_

Follow this guide if you are...

- want to add / modify core liblsl

  - Please create a `GitHub issue <https://github.com/sccn/liblsl/issues>`__
    first to ask for advice and to get pre-approval if you would like your
    modification to be included in the official library.

- build liblsl for a device / OS with no official release (e.g. an embedded Linux device)

.. _build_liblsl:

Building liblsl
***************

Before attempting to build liblsl, please make sure you have configured your :doc:`build_env`.

This part of the guide describes the process of building liblsl from source
for Windows, Mac OS X, and Linux. Since liblsl is cross-platform (it is written
in standard C++ and uses some boost libraries), this process should be pretty
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
         ├── include
         ├── lslboost
         ├── project
         ├── src
         └── testing

Configuring the liblsl project
==============================

.. note::
    Visual Studio and QtCreator users can use the integrated CMake, just open
    the folder containing :file:`CMakeLists.txt` and select the appropriate
    options.
    Please see the documentation (TODO) comparing normal CMake to Visual Studio's integrated CMake.
    If you wish to use the integrated cmake, then you do not need to follow the
    terminal commands below.

.. code:: bash

    cd liblsl
    cmake -S . -B build -G <generator name>

Note: call :samp:`cmake -G` without a generator name to get a list of available
generators.
I use :samp:`cmake -S . -B build -G "Visual Studio 16 2019" -A x64`

If you used a generator, you can now open the IDE project file. Then build the install target.

Alternatively, you can build directly from command line:
:samp:`cmake --build build -j --config Release --target install`

In either case, this will create an ``install`` folder in your build folder.
This ``install`` folder is your :doc:`LSL_INSTALL_ROOT` that you might use in when 
:doc:`building other applications.<app_dev>`

Build options for liblsl
************************

There are several liblsl-specific build options.
All of them can be set either in the GUI (cmake-gui or Visual Studio) or on the
command line (:samp:`cmake -D{foo}={bar}`).

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

.. option:: LSL_NO_FANCY_LIBNAME

  Currently, the naming scheme is
  :file:`liblsl{<ptrsize>}.{<extension>}`
  (see :ref:`liblslarch`).
  Enabling this option produces a file name that allows the default linker on
  this platform to find it if told to look for `lsl`.

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

Modifying liblsl
****************

First read :doc:`the introduction </info/intro>` to learn about LSL components and classes.
:doc:`The C++ API documentation <liblsl:index>` is a work-in-progress but might also be a good reference.


Building liblsl language bindings
*********************************

TODO


Full Tree Dev
*************

For advanced users (mostly core developers), it might be useful to simultaneously develop multiple apps and/or libraries. For this, please see the :doc:`full_tree` documentation to setup the lib and app tree,
then follow the build instructions in :doc:`build_full_tree`.
