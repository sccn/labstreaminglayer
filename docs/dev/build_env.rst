:orphan:

.. _lslbuildenv:

LSL build environment
=====================

liblsl and most apps use :ref:`buildenvcmake` and C++.

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
Windows                   XP     10 (1909)
Visual C++                2008   2019 (16.3)
OS X                      10.9   10.14 ?
XCode                     9.3    ?
Ubuntu                    16.04  19.10
CentOS                    5      ?
Clang                     3.5    9.0.0
g++                       6.2    9.0
Alpine Linux              <3.6   3.10
:ref:`buildenvcmake`      3.12   3.15
========================= ====== ===========

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

Some apps may have higher requirements while liblsl works on very old
(e.g. Windows XP) and tiny (e.g. Raspberry Pi, some microcontrollers,
Android) systems.

.. _buildenvcmake:

Note: MacOS users are expected to have `homebrew <https://brew.sh/>`__ installed.

`CMake <https://cmake.org/download/>`_
--------------------------------------

-  *Windows*: either let Visual Studio install CMake or
   download the installer (.msi extension).
   During installation, check the box to add it to the path (for all users).
-  Debian / Ubuntu: :command:`apt install cmake` or
   :command:`python -m pip install cmake`
-  Fedora: :command:`yum install cmake`
-  OS X: :command:`brew install cmake`

.. _Boost:

`Boost <https://boost.org>`__
-----------------------------

`liblsl <https://github.com/labstreaminglayer/liblsl/>`__ already
includes Boost, so you only need it to build some apps.

Boost libraries come in two flavors: header-only and compiled libraries.

For the header-only libraries you can download the source archive unpack it to
your local disk.

For compiled libraries, you either have to compile it yourself (not recommended)
or download precompiled binaries *that have to match your compiler version
and processor architecture!*
For newer apps, you should use the C++11 standard library (e.g. for threads and
regular expressions).

Afterwards, point CMake to it (:samp:`-D{BOOST_ROOT}=path/to/boost`).

Each app's build instructions should tell you exactly which boost
libraries you need.

-  Windows: install the `precompiled
   binaries <https://sourceforge.net/projects/boost/files/boost-binaries/>`__

   -  Choose the version that matches your compiler and target
      architecture (probably 64-bit). You can find the mapping between
      visual studio number and compiler version
      `here <https://en.wikipedia.org/wiki/Microsoft_Visual_C%2B%2B#Internal_version_numbering>`__.

-  Debian / Ubuntu Linux: install the ``libboost-all-dev`` package
-  OS X: install Boost via `Homebrew <https://brew.sh/>`__

MacOS
^^^^^

If you are using MacOS and homebrew, then install an old version of
boost with (e.g.) :command:`brew install boost@1.60`.
Then the cmake argument will be
:samp:`-D{BOOST_ROOT}=$(brew --prefix boost@1.60)`.
Try :command:`brew search boost` to see which older versions of boost are available.

.. _Qt5:

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

-  Windows: use the
   `installer <http://download.qt.io/official_releases/online_installers/qt-unified-windows-x86-online.exe>`__
-  Debian / Ubuntu Linux: :command:`apt install qt5-default`
-  OS X: :command:`brew install qt`
