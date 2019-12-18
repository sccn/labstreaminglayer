Library Development
###################

Follow this guide if you are...

- trying to build liblsl for a platform that does not already have a release

  - Please check the `liblsl release page <https://github.com/sccn/liblsl/releases>`_ first.
  - Please let us know so we can add the platform to the list of automated builds, if possible.

- trying to use liblsl in a language that does not already have an interface

- want to add / modify core liblsl

  - Please create a `GitHub issue <https://github.com/sccn/liblsl/issues>`__ first to ask for advice
  and to get pre-approval if you would like your modification to be included in the official library.

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

:cmd:`git clone https://github.com/sccn/liblsl.git`

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

.. code:: bash

    cd liblsl
    mkdir build && cd build
    cmake .. -G <generator name>

Note: call :cmd:`cmake -G` without a generator name to get a list of available generators.
I use :cmd:`cmake .. -G "Visual Studio 16 2019" -A x64`

If you used a generator, you can now open the IDE project file. Then build the install target.

Alternatively, you can build directly from command line:
:cmd:`cmake --build . --config Release --target install`

In either case, this will create an ``install`` folder in your build folder.
This ``install`` folder is your :doc:`LSL_INSTALL_ROOT` that you might use in when 
:doc:`building other applications.<app_dev>`

Note for Windows Users
----------------------

Please see the documentation (TODO) comparing normal CMake to Visual Studio's integrated CMake.
If you wish to use VS-integrated cmake, then you do not need to follow the terminal commands above.

Modifying liblsl
****************

First read :doc:`the introduction <../intro>` to learn about LSL components and classes.
:doc:`The C++ API documentation <liblsl:index>` is a work-in-progress but might also be a good reference.


Building liblsl language bindings
*********************************

TODO


Full Tree Dev
*************

For advanced users (mostly core developers), it might be useful to simultaneously develop multiple apps and/or libraries. For this, please see the :doc:`full_tree` documentation to setup the lib and app tree,
then follow the build instructions in :doc:`build_full_tree`.
