
.. _buildenvcmake:

CMake
=====

`CMake <https://cmake.org/>`_ is the most widely used C++ build system, so
liblsl and most labstreaminglayer apps use it to build binaries for all
major platforms.

.. _cmakeclioptions:

Command Line Options
--------------------

The basic options for the first run, i.e. to create a build folder and apply
some settings are:

.. program:: cmake

.. option:: -S path/to/the/build/folder

  (optional, if not set the current working directory is used)

.. option:: -B path/to/the/build/directory

  where the build files will be written

.. option:: -DVARIABLENAME=value

  Set a CMake variable, e.g. :samp:`cmake -D{CMAKE_BUILD_TYPE}={Release}`.

.. option:: -G "Generator"

  See :ref:`cmakegenerators`

:samp:`cmake -S . -B build -DLSL_UNITTESTS=1 -G Ninja`.

.. _cmakecommonoptions:

Common Variables
^^^^^^^^^^^^^^^^

Some often used CMake variables:

- :doc:`cmake:variable/CMAKE_INSTALL_PREFIX` (default: :file:`build/install`)
- :doc:`cmake:variable/CMAKE_BUILD_TYPE` (default: ``Release``)
- :doc:`LSL_INSTALL_ROOT`
- :ref:`QT5_DIR <qt5>`

.. _cmakegenerators:

Generators
^^^^^^^^^^

On the first run, a :doc:`CMake Generator <cmake:manual/cmake-generators.7>`
can be specified via the :option:`-G` option to set the native build system.
The defaults are ``Makefiles`` on Unix and a Visual Studio version on Windows.

Example: :command:`cmake -G "Visual Studio 16 2019"`


Building a project
------------------

Once a build folder is populated successfully, the binaries can be built either
with the native build system (e.g. ``ninja install``, ``msbuild …``) or you can
let CMake figure out which build system is used and how to run it via
:samp:`cmake --build path/to/build/folder --config Release -j --target install`.

See :ref:`cmake:build tool mode`.

Targets
-------

A :doc:`target <cmake:manual/cmake-buildsystem.7>` is either a binary to be
built (e.g. the ``liblsl`` target builds :file:`lsl.dll` on Windows, the
``LabRecorder`` target builds :file:`LabRecorder.exe` and so on), a command
to be run or an internal CMake target.

The most important CMake targets are:

``clean``
^^^^^^^^^

:command:`cmake --build . --target clean` removes all built binaries but keeps
the CMake configuration.

.. _cmakeinstalltarget:

``install``
^^^^^^^^^^^

CMake places built binary files as well as build sideproducts in a build
folder that should be separate from the source directory.
To copy only the needed files (and additional library files they depend on)
to a folder you can share with colleagues or copy onto another PC, you need to
‘install’ them.
This doesn’t mean ‘installing’ them in a traditional sense (i.e., with Windows
installers or package managers on Linux / OS X, see
:ref:`cmakepackagetarget` for that), but only copying them to a separate folder
and fixing some hardcoded paths in the binaries.


.. _cmakepackagetarget:

``package``
^^^^^^^^^^^

CMake can create packages for installed targets, e.g. ZIP files,
:doc:`Windows installers<cmake:cpack_gen/wix>` or
:doc:`Debian / Ubuntu packages<cmake:cpack_gen/deb>`.

See :doc:`the CPack manual<cmake:manual/cpack.1>` for more information.
