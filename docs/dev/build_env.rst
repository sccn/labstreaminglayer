:orphan:

.. _lslbuildenv:

LSL build environment
=====================

liblsl and most apps use :ref:`buildenvcmake` and C++.
Most apps also use Qt for a graphical user interface.

Recommended compiler toolchain
------------------------------

Download the newest toolchain you can get.

The following platforms are the supported targets for liblsl.
Most apps require newer compilers.

========================= ====== ===========
OS / Compiler             Supported Versions
------------------------- ------------------
Name                      Min    Max
========================= ====== ===========
Windows                   XP     10 (20H2)
Visual C++                2015   2019 (16.6)
OS X                      10.9   10.14 ?
XCode                     9.3    ?
Ubuntu                    16.04  20.10
CentOS                    6      ?
Clang                     3.5    9.0.0
g++                       6.2    9.0
Alpine Linux              <3.6   3.12
:ref:`buildenvcmake`      3.12   3.18
========================= ====== ===========

Some apps may have higher requirements while liblsl works on very old
(e.g. Windows XP) and tiny (e.g. Raspberry Pi, some microcontrollers,
Android) systems.

`Qt5 <http://qt.io>`__
----------------------

For compatibility with Ubuntu 16.04, Qt5.5 is the oldest supported
version.

Qt5 is the recommended toolkit to create graphical user interfaces.
To build apps using Qt, install it and if CMake doesn't find it automatically
tell it where to find it, either by adding the compiler specific base path to
the :envvar:`PATH`
(:samp:`set {PATH}=C:\Qt\<version>\<compiler_arch>;%PATH%`
on the same command line you call cmake from) or add the path to the Qt5 CMake
configuration to the cmake parameters
(:samp:`-D{Qt5_DIR}=C:/path_to/Qt/<version>/<compiler_arch>/lib/cmake/Qt5/`).


Installation: Windows
---------------------

To get a minimal Visual Studio installation, copy this block into a file and
use “Import configuration” in the
`Visual Studio 2019 <https://visualstudio.com/downloads>`_
installer:

::

   {
       "version": "1.0",
       "components": [
           "microsoft.visualstudio.component.vc.coreide",
           "microsoft.visualstudio.component.vc.cmake.project"
       ]
   }

Visual Studio (2017 and newer) includes CMake.
For a system wide CMake installation, download the
`.msi installer <https://cmake.org/download/>`__
and check the :guilabel:`Add to the path (for all users)` box.

Qt can be installed with the
`official Qt installer <http://download.qt.io/official_releases/online_installers/qt-unified-windows-x86-online.exe>`__

Installation: OS X
-------------------

Note: MacOS users are expected to have `homebrew <https://brew.sh/>`__ installed.

- :command:`brew install cmake`

- :command:`brew install qt` (not necessary for liblsl)

Installation: Debian / Ubuntu
-----------------------------

- :command:`apt install build-essentials g++ cmake`

- :command:`apt install qt5-default` (not necessary for liblsl)

`PyPI <https://pypi.org/project/cmake/>`_ has newer precompiled CMake binaries
for some architectures, you can install those via
:command:`python -m pip install cmake`.

.. _Qt5:

