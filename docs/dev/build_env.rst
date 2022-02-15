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

liblsl works on very old (e.g. Windows XP) and tiny (e.g. 
Raspberry Pi, some microcontrollers, Android) systems.
Some LSL Apps might have higher requirements.

Common Requirements
-------------------

.. _Qt:


`Qt <http://qt.io>`__
`````````````````````

For compatibility with Ubuntu 16.04, Qt5.5 is the oldest supported
version.

Qt5 or Qt6 is the recommended toolkit to create graphical user interfaces.
To build apps using Qt, install it and if CMake doesn't find it automatically
tell it where to find it, either by adding the compiler specific base path to
the :envvar:`PATH`
(:samp:`set {PATH}=C:\Qt\<version>\<compiler_arch>;%PATH%`
on the same command line you call cmake from) or add the path to the Qt CMake
configuration to the cmake parameters
(:samp:`-D{Qt5_DIR}=C:/Qt/<version>/<compiler_arch>/lib/cmake/Qt5/`).
(:samp:`-D{Qt6_DIR}=C:/Qt/<version>/<compiler_arch>/lib/cmake/Qt6/`).

.. _boost:

`Boost <https://boost.org>`__
`````````````````````````````

Nowadays, Boost is mostly used for apps connecting to a device over the local network
with Boost.Asio. As these apps don't need any parts of Boost to be built, you can
just `download Boost <https://www.boost.org/users/download/>`__, extract it somewhere
and tell CMake where to find it (:samp:`-D{BOOST_ROOT}=path/to/boost`).

Environment Configuration
-------------------------

Windows
```````

Visual Studio
'''''''''''''

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

Qt
''

Qt can be installed with the
`official Qt installer <http://download.qt.io/official_releases/online_installers/qt-unified-windows-x86-online.exe>`__

OS X
````

Note: MacOS users are expected to have `homebrew <https://brew.sh/>`__ installed.

- :command:`brew install cmake`

- :command:`brew install qt` (not necessary for liblsl)

- :command:`brew install labstreaminglayer/tap/lsl` (if you're only building an app, not liblsl itself)

Debian / Ubuntu
```````````````

Build Tools
'''''''''''

- :command:`apt install build-essential g++ cmake`

`PyPI <https://pypi.org/project/cmake/>`_ has newer precompiled CMake binaries
for some architectures, you can install those via
:command:`python -m pip install cmake`.

Qt
''

The simplest way is to install whichever version of Qt is appropriate for your distro (18.04::Qt5.9; 20.04::Qt5.12):
    - :command:`apt install qt5-default` (not necessary for liblsl)
    
However, if your app requires a newer version of Qt then the easiest way to install it is with `aqtinstall <https://aqtinstall.readthedocs.io/en/latest/>`__:
    - :command:`sudo -i`
    - :command:`apt install python3-pip`
    - :command:`pip3 install aqtinstall`

The newest version that will work with Ubuntu 18.04 is Qt 5.15.2:
    - :command:`aqt install --outputdir /opt/Qt 5.15.2 linux desktop`
    - :command:`apt-get install libxcb-xinerama0`
    - You would then use this in cmake with `-DQt5_DIR=/opt/Qt/5.15.2/gcc_64/lib/cmake/Qt5`
    
For Ubuntu 20.04, you can use Qt 6. For example:
    - :command:`aqt install --outputdir /opt/Qt 6.1.1 linux desktop`
    - You would then use this in cmake with `-DQt6_DIR=/opt/Qt/6.1.1/gcc_64/lib/cmake/Qt5`
    
For your application to run, it needs to find Qt libraries. Add the following to the bottom of your .bashrc file:
  `LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/Qt/{version}/gcc_64/lib"`  (make sure to swap out {version} for your qt version).
