App Development
===============
A LSL app is typically a (small) program that acquires data from a device (EEG amplifier, mouse, eye tracker, Wiimote) then sends it over a LSL stream, or that receives data from a LSL stream to do something meaningful with it (e.g. LabRecorder, visualization).

See :doc:`examples` for links to small examples of code,
and see the :doc:`(in progress) API documentation <liblsl:index>`.

Or see below for full applications.

C++ apps
--------
To get started with a C++ acquisition app, take a look at the `AppTemplate_cpp_qt <https://github.com/labstreaminglayer/AppTemplate_cpp_qt/>`__, a small example that provides a solid groundwork for at least the following parts:

-  license information
-  setting up a build with CMake
-  setting up a data stream in a separate thread
-  showing a graphical user interface to change the configuration and start / stop streaming data
-  save / load the configuration
-  CI configuration so binaries are almost automatically built on the three major OSes

On the AppTemplate_cpp_qt repository website click on "Use this template" to generate your own repository. Or `Click Here! <https://github.com/labstreaminglayer/AppTemplate_cpp_qt/generate>`__.

Read the annotated CMakeLists.txt file and the annotated source files for an overview of the app design and pointers about what you should change.

And of course many of the applications in the `labstreaminglayer submodules <https://github.com/sccn/labstreaminglayer/tree/master/Apps>`_ are good examples of C++ applications, most of which use Qt.

You will also need to build your C++ application. Most LabStreamingLayer applications
will follow similar :doc:`app_build` instructions. Please be sure to read the application's
README (and optionally BUILD) before building.

Python apps
-----------
Python is another great language for app development, as long as your target audience has Python and the required libraries installed.

While there are no full application templates, look at the `example code <https://github.com/labstreaminglayer/liblsl-Python/tree/master/pylsl/examples>`__ to begin.

A couple good ``pylsl`` example apps are `the one from Pupils Labs <https://github.com/labstreaminglayer/App-PupilLabs>`__, which has both a plugin and a simple application, and `SigVisualizer <https://github.com/labstreaminglayer/App-SigVisualizer>`__.

