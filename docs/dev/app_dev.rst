App Development
===============

An LSL app is typically a (small) program that acquires data from a device
(EEG amplifier, mouse, eye tracker, Wiimote) then sends it over a LSL stream, or that receives
data from a LSL stream to do something meaningful with it (e.g. LabRecorder, visualization).

The optimal application structure will depend on the data source, the data source API,
and the technology/language used to develop the application. We have several example applications,
outlined below, that may serve as a guide. In general, we have found the following structure to be
effective for most cases:

* Optionally present options to the user and wait for the user to click "Start" or "Link"
* Upon start:
    * Configure and query the device for the information needed to construct the LSL stream
        * `See the liblsl header for the minimally required information <https://github.com/sccn/liblsl/blob/48188a8f6db87bf9d4dee30e154490587342618e/include/lsl/streaminfo.h#L13-L37>`__
    * Preallocate any data buffers needed to store data from the device
    * Create the LSL StreamInfo
    * Optionally augment the StreamInfo with additional metadata
        * It is encouraged that the metadata conforms to `the XDF specifications <https://github.com/sccn/xdf/wiki/Meta-Data>`_
    * Create the outlet
* In a loop (in a thread), or via a callback:
    * Retrive data from the device
    * Push data to the outlet

See :doc:`examples` for links to small examples of code,
and see the :doc:`(in progress) API documentation <liblsl:index>`.

Or see below for full applications.

C++ apps
--------

The recommended way to get liblsl is to simply download the latest release from
`the release page <https://github.com/sccn/liblsl/releases>`__.
You may need to click on the black arrow to expand the list of assets.

If you are using CMake, pass the :doc:`LSL_INSTALL_ROOT` argument set to the location where your
liblsl file installed / unpacked to.
And your application should use something like the following line to find liblsl:

.. code-block:: cmake

  find_package(LSL 1.13.0 REQUIRED
  	HINTS ${LSL_INSTALL_ROOT}
  	"${CMAKE_CURRENT_LIST_DIR}/../../LSL/liblsl/build/"
  	"${CMAKE_CURRENT_LIST_DIR}/../../LSL/liblsl/build/install"
  	PATH_SUFFIXES share/LSL
  )

Then you can link your target to liblsl with ``target_link_libraries(${PROJECT_NAME} PRIVATE LSL::lsl)``.

For a more complete example to help you get started with a C++ acquisition app, take a look at the `AppTemplate_cpp_qt <https://github.com/labstreaminglayer/AppTemplate_cpp_qt/>`__, a small example that provides a solid groundwork for at least the following parts:

-  license information
-  setting up a build with CMake
-  setting up a data stream in a separate thread
-  showing a graphical user interface to change the configuration and start / stop streaming data
-  save / load the configuration
-  CI configuration so binaries are almost automatically built on the three major OSes

On the `AppTemplate_cpp_qt <https://github.com/labstreaminglayer/AppTemplate_cpp_qt/>`__
repository website click on
`"Use this template" <https://github.com/labstreaminglayer/AppTemplate_cpp_qt/generate>`__
to generate your own repository.

Read the annotated CMakeLists.txt file and the annotated source files for an overview of the app design and pointers about what you should change.

And of course many of the applications in the `labstreaminglayer submodules <https://github.com/sccn/labstreaminglayer/tree/master/Apps>`_ are good examples of C++ applications, most of which use Qt.

You will also need to build your C++ application. Most LabStreamingLayer applications
will follow similar :doc:`app_build` instructions. Please be sure to read the application's
README (and optionally BUILD) before building.

Python apps
-----------
Python is another great language for app development, as long as your target audience has Python and the required libraries installed.
You (and other app users) will need to have ``pylsl`` installed. The recommended way to get it is with ``pip install pylsl``.

While there are no full application templates, look at the `example code <https://github.com/labstreaminglayer/liblsl-Python/tree/master/pylsl/examples>`__ to begin.

A couple good ``pylsl`` example apps are the one from :lslrepo:`PupilLabs`,
which has both a plugin and a simple application, and :lslrepo:`SigVisualizer`.


Windows Users
-------------

If users of applications linked to liblsl are encountering errors related to not being able to load the DLL, in particular missing a VCRUNTIME140_1.dll (or similar), then they probably need to install the `latest Microsoft Visual C++ Redistributable <https://support.microsoft.com/en-ca/help/2977003/the-latest-supported-visual-c-downloads>`__ for the application architecture

