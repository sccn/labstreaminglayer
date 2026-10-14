Getting LSL
###########

What you need depends on what you want to do:

* **Record or view streams, or stream from a supported device:** download the application.
  :doc:`LabRecorder <tools>` and the :doc:`device apps <supported_devices>` have ready-made
  downloads on their release pages, and they include the library.
* **Write a program in Python, MATLAB, C#, Java, ...:** install the
  :doc:`language binding <language_wrappers>`. Most bindings bundle liblsl or tell you where
  to get it (e.g. ``pip install pylsl``).
* **Write a program in C or C++, or build a binding:** use liblsl directly, as described below.

liblsl
======

liblsl is the C/C++ library that every LSL application and binding uses. Its own documentation
covers in detail how to :liblsl:`get it <guide/getting.html>`,
:liblsl:`use it in your project <guide/linking.html>` and
:liblsl:`build it <guide/building.html>`. In short:

* **Build it with your project.** C/C++ projects using CMake can add liblsl with
  ``FetchContent`` and link the ``LSL::lsl`` target. This always gives you exactly the version
  you ask for, built with your compiler.
* **Release downloads.** Every `liblsl release <https://github.com/sccn/liblsl/releases>`__
  has builds for Windows (x64, x86, ARM64, and MinGW), Ubuntu (``.deb``, x64/ARM), macOS (an
  installer for ``lsl.framework``) and an ``xcframework`` for macOS and iOS. These are built and
  tested by the liblsl repository's own CI.
* **Package managers.** liblsl is also available from:

  * `conda-forge <https://anaconda.org/conda-forge/liblsl>`__: ``conda install -c conda-forge liblsl``
  * `vcpkg <https://vcpkg.io>`__: ``vcpkg install liblsl``
  * `Conan <https://conan.io/center/liblsl>`__
  * `Homebrew <https://brew.sh>`__: ``brew install labstreaminglayer/tap/lsl``

  .. warning::
     These packages are maintained separately from liblsl and are updated by hand after each
     release, so they are often one or more releases behind (check the version they offer).
     The best-supported routes are the release downloads and building liblsl with your project
     through its CMake integration, which liblsl's CI tests on every change.

Apps and the full source tree
=============================

Applications live in their own repositories under
`github.com/labstreaminglayer <https://github.com/labstreaminglayer>`__; each has a release page
with downloads and a README with build instructions. The
`labstreaminglayer repository <https://github.com/sccn/labstreaminglayer>`__ collects them all as
git submodules together with this documentation.
