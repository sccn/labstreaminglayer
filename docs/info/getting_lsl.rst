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

liblsl, the C/C++ library under every LSL application and binding, comes as release downloads for
Windows, Linux, macOS and iOS, from package managers (conda-forge, vcpkg, Conan, Homebrew), or
built as part of your own CMake project. :liblsl:`Getting liblsl <guide/getting.html>` lists them
all; :liblsl:`Using liblsl in your project <guide/linking.html>` shows how to link it.

The package-manager versions are maintained separately and are often a release or more behind;
the release downloads and liblsl's own CMake integration are the best-supported routes.

Apps and the full source tree
=============================

Applications live in their own repositories under
`github.com/labstreaminglayer <https://github.com/labstreaminglayer>`__; each has a release page
with downloads and a README with build instructions. The
`labstreaminglayer repository <https://github.com/sccn/labstreaminglayer>`__ collects them all as
git submodules together with this documentation.
