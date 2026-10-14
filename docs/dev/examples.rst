:orphan:

LSL Coding Examples
###################

There are essentially two types of programs interacting with LSL: programs that provide data, such as a data source that represents a particular acquisition device, and programs that consume data (and occasionally mixtures of the two), such as a viewer, a recorder, or a program that takes some action based on real-time data.

The main difference between LSL and other data transport interfaces is that it is not connection-oriented (although the underlying implementation uses connection-oriented transport). It is closer to a "publish-subscribe" model. A data producer creates a named "outlet" object (perhaps with meta-data) and pushes samples into it without ever caring about who is listening. So functionally it is offering a stream of data plus some meta-data about it.

A data consumer who is interested in a particular type of stream queries the network for a matching one ("resolves it"), for example based on the name, type or some other content-based query and then creates an "inlet" object to receive samples from the stream. It can also separately obtain the meta-data of the stream. The consumer then pulls out samples from the stream. The sequence of samples that the consumer sees is in order, without omissions (unless a buffer's memory is exhausted), and type-safe. The data is buffered at both endpoints if there are transmission delays anywhere (e.g., interrupted network connection) but otherwise delivered as fast as the system allows.

The objects and functions to perform these tasks are provided by a single cross-platform library (liblsl). The library comes with a C header file, a C++ header file and wrapper classes for other languages.

Note: if you have trouble establishing communication between these programs across different computers especially on Windows, take a look at the NetworkConnectivity page and read the Network Troubleshooting section.

API Documentation
*****************

It is recommended that you clone the repository to get the respective code. The documentation is at the following locations:
  * C and C++: the :doc:`liblsl API reference <liblsl:index>` (from the
    `C <https://github.com/sccn/liblsl/blob/main/include/lsl_c.h>`__ and
    `C++ <https://github.com/sccn/liblsl/blob/main/include/lsl_cpp.h>`__ headers)
  * Python: `pylsl module <https://github.com/labstreaminglayer/pylsl>`__
  * Java: `JavaDocs <https://github.com/labstreaminglayer/liblsl-Java/blob/master/javadoc/index.html>`__
  * C#: `LSL module <https://github.com/labstreaminglayer/liblsl-Csharp/blob/master/LSL.cs>`__
  * MATLAB: `class files <https://github.com/labstreaminglayer/liblsl-Matlab>`__.
  * Other languages (R, Octave, Ruby, Lua, Perl, Go): `SWIG interfaces <https://github.com/labstreaminglayer/liblsl-Generic>`__ (the C or C++ header file is the API reference).

The API documentation covers all classes, functions and types and should
hopefully leave no questions unanswered.
Note that a typical application will only need a small subset of the API
(as used in the example programs).

C and C++ Example Programs
**************************

liblsl's `examples folder <https://github.com/sccn/liblsl/tree/main/examples>`__ has C and C++
programs from basic to advanced: sending and receiving time series (sample by sample and in
chunks), string event markers, stream metadata, resolving all streams on the network, reading a
stream's full metadata, and querying time correction. Its
`README <https://github.com/sccn/liblsl/blob/main/examples/README.md>`__ walks through them, and
:liblsl:`Using liblsl in your project <guide/linking.html>` shows how to build them.

Python Example Programs: Basic to Advanced
******************************************
These examples show how to transmit a numeric multi-channel time series through LSL:
  * `Sending a multi-channel time series into LSL. <https://github.com/labstreaminglayer/pylsl/blob/main/src/pylsl/examples/SendData.py>`__
  * `Receiving a multi-channel time series from LSL. <https://github.com/labstreaminglayer/pylsl/blob/main/src/pylsl/examples/ReceiveData.py>`__

The following examples show how to send and receive data in chunks, which can be more convenient. The data sender also demonstrates how to attach meta-data to the stream.
  * `Sending a multi-channel time series in chunks. <https://github.com/labstreaminglayer/pylsl/blob/main/src/pylsl/examples/SendDataAdvanced.py>`__
  * `Receiving a multi-channel time series in chunks. <https://github.com/labstreaminglayer/pylsl/blob/main/src/pylsl/examples/ReceiveDataInChunks.py>`__

These examples show a special-purpose use case that is mostly relevant for stimulus-presentation programs or other applications that want to emit 'event' markers or other application state. The stream here is single-channel and has irregular sampling rate, but the value per channel is a string:
  * `Sending string-formatted irregular streams. <https://github.com/labstreaminglayer/pylsl/blob/main/src/pylsl/examples/SendStringMarkers.py>`__
  * `Receiving string-formatted irregular streams. <https://github.com/labstreaminglayer/pylsl/blob/main/src/pylsl/examples/ReceiveStringMarkers.py>`__

The last example shows how to attach properly formatted meta-data to a stream, and how to read it out again at the receiving end. While meta-data is strictly optional, it is very useful to make streams self-describing. LSL has adopted the convention to name meta-data fields according to the XDF file format specification whenever the content type matches (for example EEG, Gaze, MoCap, VideoRaw, etc); the spec is `here <https://github.com/sccn/xdf/wiki/Meta-Data>`__. Note that some older example programs (SendData/ReceiveData) predate this convention and name the channels inconsistently.
  * `Handling stream meta-data. <https://github.com/labstreaminglayer/pylsl/blob/main/src/pylsl/examples/HandleMetadata.py>`__

MATLAB Example Programs: Basic to Advanced
******************************************
These examples show how to transmit a numeric multi-channel time series through LSL:
  * `Sending a multi-channel time series into LSL. <https://github.com/labstreaminglayer/liblsl-Matlab/tree/master/examples/SendData.m>`__
  * `Receiving a multi-channel time series from LSL. <https://github.com/labstreaminglayer/liblsl-Matlab/tree/master/examples/ReceiveData.m>`__

These examples do the same as before, but now transmit the data at the granularity of chunks. For the purposes of network transmission the same effect can be achieved by creating the inlet or outlet with an extra argument to indicate that multiple samples should be batched into a chunk for transmission. However, since MATLAB's interpreter is relatively slow, the library calls should be made in a vectorized manner, i.e. at chunk granularity, whenever possible (at least for high-rate streams). Note that for LSL the data is always a linear sequence of samples and data that is pushed as samples can be pulled out as chunks or vice versa:
  * `Sending data at chunk granularity. <https://github.com/labstreaminglayer/liblsl-Matlab/tree/master/examples/SendDataInChunks.m>`__
  * `Receiving data at chunk granularity. <https://github.com/labstreaminglayer/liblsl-Matlab/tree/master/examples/ReceiveDataInChunks.m>`__

These examples show a special-purpose use case that is mostly relevant for stimulus-presentation programs or other applications that want to emit 'event' markers or other application state. The stream here is single-channel and has irregular sampling rate, but the value per channel is a string:
  * `Sending string-formatted irregular streams. <https://github.com/labstreaminglayer/liblsl-Matlab/tree/master/examples/SendStringMarkers.m>`__
  * `Receiving string-formatted irregular streams. <https://github.com/labstreaminglayer/liblsl-Matlab/tree/master/examples/ReceiveStringMarkers.m>`__

The last example shows how to attach properly formatted meta-data to a stream, and how to read it out again at the receiving end. While meta-data is strictly optional, it is very useful to make streams self-describing. LSL has adopted the convention to name meta-data fields according to the XDF file format specification whenever the content type matches (for example EEG, Gaze, MoCap, VideoRaw, etc); the spec is `here <https://github.com/sccn/xdf/wiki/Meta-Data>`__. Note that some older example programs (SendData/ReceiveData) predate this convention and name the channels inconsistently.
  * `Handling stream meta-data. <https://github.com/labstreaminglayer/liblsl-Matlab/tree/master/examples/HandleMetaData.m>`__

Java Example Programs: Basic to Advanced
****************************************
These examples show how to transmit a numeric multi-channel time series through LSL:
  * `Sending a multi-channel time series into LSL. <https://github.com/labstreaminglayer/liblsl-Java/tree/master/src/examples/SendData.java>`__
  * `Receiving a multi-channel time series from LSL. <https://github.com/labstreaminglayer/liblsl-Java/tree/master/src/examples/ReceiveData.java>`__

The following examples show how to transmit data in form of chunks instead of samples, which can be more convenient.
  * `Sending a multi-channel time series in chunks. <https://github.com/labstreaminglayer/liblsl-Java/tree/master/src/examples/SendDataInChunks.java>`__
  * `Receiving a multi-channel time series in chunks. <https://github.com/labstreaminglayer/liblsl-Java/tree/master/src/examples/ReceiveDataInChunks.java>`__

These examples show a special-purpose use case that is mostly relevant for stimulus-presentation programs or other applications that want to emit 'event' markers or other application state. The stream here is single-channel and has irregular sampling rate, but the value per channel is a string:
  * `Sending string-formatted irregular streams. <https://github.com/labstreaminglayer/liblsl-Java/tree/master/src/examples/SendStringMarkers.java>`__
  * `Receiving string-formatted irregular streams. <https://github.com/labstreaminglayer/liblsl-Java/tree/master/src/examples/ReceiveStringMarkers.java>`__

The last example shows how to attach properly formatted meta-data to a stream, and how to read it out again at the receiving end. While meta-data is strictly optional, it is very useful to make streams self-describing. LSL has adopted the convention to name meta-data fields according to the XDF file format specification whenever the content type matches (for example EEG, Gaze, MoCap, VideoRaw, etc); the spec is `here <https://github.com/sccn/xdf/wiki/Meta-Data>`__. Note that some older example programs (SendData/ReceiveData) predate this convention and name the channels inconsistently.
  * `Handling stream meta-data. <https://github.com/labstreaminglayer/liblsl-Java/tree/master/src/examples/HandleMetaData.java>`__

C# Example Programs: Basic to Advanced
**************************************
These examples show how to transmit a numeric multi-channel time series through LSL:
  * `Sending a multi-channel time series into LSL. <https://github.com/labstreaminglayer/liblsl-Csharp/blob/master/examples/SendData/SendData.cs>`__
  * `Receiving a multi-channel time series from LSL. <https://github.com/labstreaminglayer/liblsl-Csharp/blob/master/examples/ReceiveData/ReceiveData.cs>`__

The following examples show how to transmit data in form of chunks instead of samples, which can be more convenient.
  * `Sending a multi-channel time series in chunks. <https://github.com/labstreaminglayer/liblsl-Csharp/blob/master/examples/SendDataInChunks/SendDataInChunks.cs>`__
  * `Receiving a multi-channel time series in chunks. <https://github.com/labstreaminglayer/liblsl-Csharp/blob/master/examples/ReceiveDataInChunks/ReceiveDataInChunks.cs>`__

These examples show a special-purpose use case that is mostly relevant for stimulus-presentation programs or other applications that want to emit 'event' markers or other application state. The stream here is single-channel and has irregular sampling rate, but the value per channel is a string:
  * `Sending string-formatted irregular streams. <https://github.com/labstreaminglayer/liblsl-Csharp/blob/master/examples/SendStringMarkers/SendStringMarkers.cs>`__
  * `Receiving string-formatted irregular streams. <https://github.com/labstreaminglayer/liblsl-Csharp/blob/master/examples/ReceiveStringMarkers/ReceiveStringMarkers.cs>`__

The last example shows how to attach properly formatted meta-data to a stream, and how to read it out again at the receiving end. While meta-data is strictly optional, it is very useful to make streams self-describing. LSL has adopted the convention to name meta-data fields according to the XDF file format specification whenever the content type matches (for example EEG, Gaze, MoCap, VideoRaw, etc); the spec is `here <https://github.com/sccn/xdf/wiki/Meta-Data>`__. Note that some older example programs (SendData/ReceiveData) predate this convention and name the channels inconsistently.
  * `Handling stream meta-data. <https://github.com/labstreaminglayer/liblsl-Csharp/blob/master/examples/HandleMetaData/HandleMetaData.cs>`__

Real-World Example Programs
***************************
These sample codes are from actual 'production' software that is used to do data transmission:
  * :lslrepo:`KinectMocap`: multi-channel signal with body joint positions and meta-data.
  * :lslrepo:`Input`: irregular marker stream based on keyboard inputs. 
  * :lslrepo:`BAlert`: reading from an EEG device in a separate thread.
  * :lslrepo:`EyeLink`: reading from an eye tracker in Python.

Also, all applications in the Apps directory are open-source and can serve as examples, and most of them are very similar in how they pass on data to LSL.
