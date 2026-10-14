:orphan:

``LSL_INSTALL_ROOT``
====================

Many LSL apps accept ``-DLSL_INSTALL_ROOT=<path>`` when configuring with CMake. It is a hint for
``find_package(LSL)`` and should point to a liblsl install prefix: the folder that contains
``lib/`` and ``include/``, e.g. an extracted release archive or the result of ``cmake --install``.
Adding the same folder to ``CMAKE_PREFIX_PATH`` works for any CMake project.

See :liblsl:`Using liblsl in your project <guide/linking.html>` for all the ways to find and link liblsl.
