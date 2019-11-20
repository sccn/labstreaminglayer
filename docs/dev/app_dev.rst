App Development
===============
A LSL app is typically a (small) program that acquires data from a device (EEG amplifier, mouse, eye tracker, Wiimote) then sends it over a LSL stream, or that receives data from a LSL stream to do something meaningful with it (e.g. LabRecorder, visualization).

See :doc:`examples` for links to small examples of code,
and see the :doc:`(in progress) API documentation <liblsl:index>`.

Or see below for full applications.

C++ apps
--------
To get started with a C++ acquisition app, take a look at the `BestPracticesGUI <https://github.com/labstreaminglayer/App-BestPracticesGUI/>`__, a small example that provides a solid groundwork for at least the following parts:

-  license information
-  setting up a build with CMake
-  showing a graphical user interface to change the configuration and start / stop streaming data from a fictitious device to the network in a separate thread
-  save / load the configuration
-  CI configuration so binaries are almost automatically built on the three major OSes

You can copy the `app skeleton <https://github.com/labstreaminglayer/App-BestPracticesGUI/tree/master/appskeleton>`__ to a new repository to get started and read the `annotated source files <https://github.com/labstreaminglayer/App-BestPracticesGUI/tree/master/doc>`__ for an overview over the design decisions and things you should change.

And of course many of the applications in the `labstreaminglayer submodules <https://github.com/sccn/labstreaminglayer/tree/master/Apps>`_ are good examples of C++ applications, most of which use Qt.

Python apps
-----------
Python is another great language for app development, as long as your target audience has Python and the required libraries installed. While there are no full application examples, `Pupils Labs <https://github.com/labstreaminglayer/App-PupilLabs>`__ has both a plugin and a simple application that provide a good demonstration of using ``pylsl``.
