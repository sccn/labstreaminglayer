# App development

An app is a (small) program that acquires data from a device (EEG amplifier,
mouse, eye tracker, Wiimote) or receives data to do something meaningful with
it (e.g. LabRecorder, visualization).

## C++ apps

To get started with a C++ acquisition app, take a look at the
[BestPracticesGUI](https://github.com/labstreaminglayer/App-BestPracticesGUI/),
a small example that provides a solid groundwork for at least the following
parts:

- license information
- setting up a build with CMake
- showing a graphical user interface to change the configuration and start /
  stop streaming data from a fictitious device to the network in a separate
  thread
- save / load the configuration
- [CI](CI.md) configuration so binaries are almost automatically built on the
  three major OSes

You can copy the [app skeleton](https://github.com/labstreaminglayer/App-BestPracticesGUI/tree/master/appskeleton)
to a new repository to get started and read the
[annotated source files](https://github.com/labstreaminglayer/App-BestPracticesGUI/tree/master/doc)
for an overview over the design decisions and things you should change.


