:orphan:

.. role:: cmd(code)
   :language: bash

``LSL_INSTALL_ROOT``
====================

To import the LSL library in a separate CMake build, you need to set the
the **absolute path** to the `‘installed’ LSL
directory <#install-directory-tree>`__ in the ``LSL_INSTALL_ROOT``
variable (e.g. :cmd:`-DLSL_INSTALL_ROOT=C:/LSL/build/install/`) or add the
**absolute path** to the\ ``LSL/cmake`` subfolder of the `‘installed’
LSL directory <#install-directory-tree>`__ to your ``CMAKE_PREFIX_PATH``
(:cmd:`list(APPEND CMAKE_MODULE_PATH "C:/path/to/LSL/build/install/cmake/")`).

CMake looks for the file
``${LSL_INSTALL_ROOT}/LSL/share/LSL/LSLConfig.cmake``, so make sure your
``LSL_INSTALL_ROOT`` has the files listed in `the previous
section <#installed-directory-tree>`__.

By default, apps should look in ``../../LSL/liblsl/build/install`` so if
you have a ``build`` folder in each submodule (``LSL/liblsl/build``,
``Apps/Examples/build`` etc.) and installed ``liblsl`` first, CMake
automatically finds liblsl.
