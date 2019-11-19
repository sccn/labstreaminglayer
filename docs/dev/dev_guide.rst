Developer's Guide
=================

Add introductory text here.

The distribution includes a range of code examples in C, C++, Python, MATLAB, Java, and C# including some very simple sender and receiver programs, as well as some fairly extensive demo apps.

See `Example Applications <https://github.com/labstreaminglayer/App-Examples/>`__ for a broader overview of example programs, API documentation link, and general programming tips, tricks, and frequently asked questions.

# Coding Guides
The distribution includes a range of code examples in C, C++, Python, MATLAB, Java, and C# including some very simple sender and receiver programs, as well as some fairly extensive demo apps. This page includes just some simple teasers. See [[ExampleCode|ExampleCode]]for a broader overview of example programs, API documentation link, and general programming tips, tricks, and frequently asked questions.

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
