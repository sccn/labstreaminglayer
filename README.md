# Summary

The **lab streaming layer** (LSL) is a system for the unified collection of measurement time series in research experiments that handles both the networking, time-synchronization, (near-) real-time access as well as optionally the centralized collection, viewing and disk recording of the data.

The **LSL distribution** consists of:
  * The core transport library (liblsl) and its language interfaces (C, C++, Python, Java, C#, MATLAB). The library is general-purpose and cross-platform (Win/Linux/MacOS, 32/64) and forms the heart of the project.
  * A suite of tools built on top of the library, including a [recording program](https://github.com/sccn/labstreaminglayer/wiki/LabRecorder.wiki), [online viewers](https://github.com/sccn/labstreaminglayer/wiki/ViewingStreamsInMatlab.wiki), [importers](https://github.com/sccn/labstreaminglayer/wiki/ImportingRecordingsInMatlab.wiki), and apps that make data from a range of [acquisition hardware](https://github.com/sccn/labstreaminglayer/wiki/SupportedDevices.wiki) available on the lab network (for example audio, EEG, or motion capture).

There is an intro lecture/demo on LSL here: [http://www.youtube.com/watch?v=Y1at7yrcFW0](http://www.youtube.com/watch?v=Y1at7yrcFW0) (part of an online course on EEG-based brain-computer interfaces).

You may also wish to subscribe to the LSL mailing list here: [https://mailman.ucsd.edu/mailman/listinfo/lsl-l](https://mailman.ucsd.edu/mailman/listinfo/lsl-l).

Hosted here is only the source code for the project. Develpers will want to clone this repo, then run 'python get_deps.py' to download all the 3rd party libraries from our ftp. 

# Download Binary Releases

You can find recent releases on our FTP site : ftp://sccn.ucsd.edu/pub/software/LSL/

These releases may be slightly out of date. We are working toward an automated build and deployment system but it is not ready yet.

# Building from source

Follow the instructions in the INSTALL.md file.

# Streaming Layer API

The liblsl library provides the following **abstractions** for use by client programs:

  * **Stream Outlets**: for making time series data streams available on the lab network. The data is pushed sample-by-sample or chunk-by-chunk into the outlet, and can consist of single- or multichannel data, regular or irregular sampling rate, with uniform value types (integers, floats, doubles, strings). Streams can have arbitrary XML meta-data (akin to a file header). By creating an outlet the stream is made visible to a collection of computers (defined by the network settings/layout) where one can subscribe to it by creating an inlet.

  * **Resolve functions**: these allow to resolve streams that are present on the lab network according to content-based queries (for example, by name, content-type, or queries on the meta-data). The service discovery features do not depend on external services such as zeroconf and are meant to drastically simplify the data collection network setup.

  * **Stream Inlets**: for receiving time series data from a connected outlet. Allows to retrieve samples from the provider (in-order, with reliable transmission, optional type conversion and optional failure recovery). Besides the samples, the meta-data can be obtained (as XML blob or alternatively through a small built-in DOM interface).

  * **Built-in clock**: Allows to time-stamp the transmitted samples so that they can be mutually synchronized. See Time Synchronization.

# Reliability
The following reliability features are implemented by the library (transparently):
  * Transport inherits the reliability of TCP, is message-oriented (partitioned into samples) and type safe.

  * The library provides automatic failure recovery from application or computer crashes to minimize data loss (optional); this makes it possible to replace a computer in the middle of a recording without having to restart the data collection.

  * Data is buffered both at the sender and receiver side (with configurable and arbitrarily large buffers) to tolerate intermittent network failures.

  * Transmission is type safe, and supports type conversions as necessary.

# Time Synchronization
The lab streaming layer comes with a built-in synchronized time facility for all recorded data which is designed to achieve sub-millisecond accuracy on a local network of computers. This facility serves to provide out-of-the-box support for synchronized data collection but does not preclude the use of user-supplied alternative timestamps, for example from commercial timing middleware or high-quality clocks.

The built-in time synchronization is designed after the widely deployed Network Time Protocol (NTP) and implemented in the LSL library. This feature is explained in more detail in the [TimeSynchronization](https://github.com/sccn/labstreaminglayer/wiki/TimeSynchronization.wiki) section.
# File Format
The transport API itself does not endorse or provide a particular file format, but the provided recording program (`LabRecorder`) and Python/C++ library (`RecorderLib`) record into the XDF file format (Extensible Data Format, hosted at https://github.com/sccn/xdf). XDF was designed concurrently with the lab streaming layer and supports the full feature set of LSL (including multi-stream container files, per-stream arbitrarily large XML headers, all sample formats as well as time-synchronization information).

# Coding Guides
The distribution includes a range of code examples in C, C++, Python, MATLAB, Java, and C# including some very simple sender and receiver programs, as well as some fairly extensive demo apps. This page includes just some simple teasers. See [ExampleCode](https://github.com/sccn/labstreaminglayer/wiki/ExampleCode.wiki) for a broader overview of example programs, API documentation link, and general programming tips, tricks, and frequently asked questions.

## Sending Random Data in C++
```
#include "lsl_cpp.h"
#include <stdlib.h>
using namespace lsl;

/**
 * This is an example of how a simple data stream can be offered on the network. 
 * Here, the stream is named SimpleStream, has content-type EEG, and 128 channels.
 * The transmitted samples contain random numbers (and the sampling rate is irregular 
 * and effectively bounded by the speed at which the program can push out samples).
 */

int main(int argc, char* argv[]) {

	// make a new stream_info (128ch) and open an outlet with it
	stream_info info("SimpleStream","EEG",128);
	stream_outlet outlet(info);

	// send data forever
	float sample[128];
	while(true) {
		// generate random data
		for (int c=0;c<128;c++)
			sample[c] = (rand()%1500)/500.0-1.5;
		// send it
		outlet.push_sample(sample);
	}

	return 0;
}
```

## Receiving Data in C++
```
#include "lsl_cpp.h"

/**
 * This is a minimal example that demonstrates how a multi-channel stream (here 128ch) 
 * of a particular name (here: SimpleStream) can be resolved into an inlet, and how the 
 * raw sample data & time stamps are pulled from the inlet. This example does not 
 * display the obtained data.
 */

int main(int argc, char* argv[]) {
	using namespace lsl;

	// resolve the stream of interest & make an inlet to get data from the first result
	std::vector<stream_info> results = resolve_stream("name","SimpleStream");
	stream_inlet inlet(results[0]);

	// receive data & time stamps forever (not displaying them here)
	float sample[128];
	while (true)
		double ts = inlet.pull_sample(&sample[0],128);
	
	return 0;
}
```

# How to get support
If you are having trouble with LSL, there are few things you can do to get help.
First, search this GitHub repository's issues list, including closed issues.
If you don't find what you are looking for, then you can create a new issue. Try to include as much information as possible about your device (if applicable), your computing environment (operating system, processor achitecture), what you have tested so far, and also provide logs or other error messages if available. If you end up creating a new issue, please close it once the issue is solved.
You can also try joining the LabStreamingLayer `#users` channel on Slack. [Invite Link](https://join.slack.com/t/labstreaminglayer/shared_invite/enQtMzA2NjEwNDk0NjA5LWI2MmI4MjBhYjgyMmRmMzg2NzEzODc2M2NjNDIwODhmNzViZmRmMWQyNTBkYzkwNmUyMzZhOTU5ZGFiYzkzMzQ). Someone there may be able to get to the bottom of your problem through conversation.

# Acknowledgements
The original version of this software was written at the [Swartz Center for Computational Neuroscience](http://sccn.ucsd.edu/people/), UCSD. This work was funded by the Army Research Laboratory under Cooperative Agreement Number W911NF-10-2-0022 as well as through NINDS grant 3R01NS047293-06S1.
