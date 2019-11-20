Introduction
############

What is LSL?
************

The **LSL distribution** consists of the core library and a suite of tools built on top of the library.

The core transport library is `liblsl <https://github.com/labstreaminglayer/liblsl/>`__ and its language interfaces (`C <https://github.com/sccn/liblsl/>`__, `C++ <https://github.com/sccn/liblsl/>`__, `Python <https://github.com/labstreaminglayer/liblsl-Python/>`__, `Java <https://github.com/labstreaminglayer/liblsl-Java/>`__, `C# <https://github.com/labstreaminglayer/liblsl-Csharp/>`__, `MATLAB <https://github.com/labstreaminglayer/liblsl-Matlab/>`__).
The library is general-purpose and cross-platform (OS Support: Win / Linux / MacOS / `Android <https://github.com/labstreaminglayer/liblsl-Android/>`__ / iOS; Architecture Support: x86 / amd64 / arm).

The suite of tools includes a `recording program <https://github.com/labstreaminglayer/App-LabRecorder>`__, `file importers <https://github.com/sccn/xdf>`__, and apps that make data from a range of acquisition hardware (see :doc:`supported_devices`) available on the lab network (for example audio, EEG, or motion capture).

There is an intro lecture/demo on LSL here: http://www.youtube.com/watch?v=Y1at7yrcFW0 (part of an online course on EEG-based brain-computer interfaces).

Streaming Layer API
===================

The liblsl library provides the following **abstractions** for use by client programs:

- **Stream Outlets**: for making time series data streams available on the lab network. The data is pushed sample-by-sample or chunk-by-chunk into the outlet, and can consist of single- or multichannel data, regular or irregular sampling rate, with uniform value types (integers, floats, doubles, strings). Streams can have arbitrary XML meta-data (akin to a file header). By creating an outlet the stream is made visible to a collection of computers (defined by the network settings/layout) where one can subscribe to it by creating an inlet.
- **Resolve functions**: these allow to resolve streams that are present on the lab network according to content-based queries (for example, by name, content-type, or queries on the meta-data). The service discovery features do not depend on external services such as zeroconf and are meant to drastically simplify the data collection network setup.
- **Stream Inlets**: for receiving time series data from a connected outlet. Allows to retrieve samples from the provider (in-order, with reliable transmission, optional type conversion and optional failure recovery). Besides the samples, the meta-data can be obtained (as XML blob or alternatively through a small built-in DOM interface).
- **Built-in clock**: Allows to time-stamp the transmitted samples so that they can be mutually synchronized. See Time Synchronization.

Reliability
===========

The following reliability features are implemented by the library (transparently):

- Transport inherits the reliability of TCP, is message-oriented (partitioned into samples) and type safe.
- The library provides automatic failure recovery from application or computer crashes to minimize data loss (optional); this makes it possible to replace a computer in the middle of a recording without having to restart the data collection.
- Data is buffered both at the sender and receiver side (with configurable and arbitrarily large buffers) to tolerate intermittent network failures.
- Transmission is type safe, and supports type conversions as necessary.

Time Synchronization
====================

The lab streaming layer comes with a built-in synchronized time facility for all recorded data which is designed to achieve sub-millisecond accuracy on a local network of computers. This facility serves to provide out-of-the-box support for synchronized data collection but does not preclude the use of user-supplied alternative timestamps, for example from commercial timing middleware or high-quality clocks.

The built-in time synchronization is designed after the widely deployed Network Time Protocol (NTP) and implemented in the LSL library.

This feature is explained in more detail in the `TimeSynchronization <https://labstreaminglayer.readthedocs.io/en/latest/info/time_synchronization.html>`__ section.

File Format
===========

The transport API itself does not endorse or provide a particular file format, but the provided recording program (``LabRecorder``) records into the XDF file format (`Extensible Data Format <https://github.com/sccn/xdf>`__). XDF was designed concurrently with the lab streaming layer and supports the full feature set of LSL (including multi-stream container files, per-stream arbitrarily large XML headers, all sample formats as well as time-synchronization information).

Developer Information
=====================

Please see the separate `build documentation <https://labstreaminglayer.readthedocs.io/en/latest/dev/dev_guide.html>`__.
