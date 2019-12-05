FAQs
####

Get the newest sample
---------------------

I want to check the most recent sample of a stream every few seconds.
How do I do that?

Because the result of :cpp:func:`~lsl::stream_inlet::pull_sample()` is the next
sample in the order provided by the sender, you first need to pull out all
samples that have been buffered up in the inlet. You can do this by calling
:cpp:func:`~lsl::stream_inlet::pull_sample()` with a timeout of ``0.0`` -- once
it returns zero, there are no more samples.

To speed this up, you can set a short buffer size when creating the inlet
(i.e. set the
:cpp:any:`~lsl::stream_inlet::stream_inlet::max_buflen`
parameter of the :cpp:func:`~lsl::stream_inlet::stream_inlet()`
constructor to e.g., one second), so that older samples are automatically
discarded when the buffer is full.

lsl_local_clock() 
-----------------

What clock does LSL use? / 
How do I relate LSL's :cpp:func:`lsl_local_clock()` to my wall clock?

LSL's :cpp:func:`lsl_local_clock()` function measures the number of seconds
from a starting point,
e.g. since the local machine was started or since 1970-01-01 00:00.

Clock jumps, e.g. when suspending the system or resetting the clock (e.g. by a
network clock sychronization service like NTP) shouldn't occur.

The correct way to map its output to the time measured by your preferred system
clock is to first determine the constant offset between the two clocks, by
reading them out at the same time, and then to add that offset to the result
of :cpp:func:`lsl_local_clock()` whenever it is needed.

Also keep in mind that the time-stamps that are returned by
:cpp:func:`~lsl::stream_inlet::pull_sample()`
will generally be local to the sender's machine unless you set the
:cpp:enumerator:`proc_clocksync` or 
:cpp:enumerator:`proc_ALL` postprocessing flags at inlet creation time.
Otherwise, you have to add the time offset returned by
:cpp:func:`lsl::stream_inlet::time_correction()`
to the timestamps to have them in your local domain.

Latency
-------

What is the latency of LSL?
Does the chosen buffer size have anything to do with it?

The latency of LSL is typically under 0.1 milliseconds on a local machine,
unless a very large amount of data is transmitted (megabytes per sample).
The buffer size does not affect the latency unless you allow data to queue up
by not querying it for an extended period of time (or when the network
connection is temporarily interrupted).
In such a case, the queued-up data will be quickly transmitted in a burst once
network connectivity is restored.
If you only need a limited backlog of data, you can set a shorter buffer size
when creating the inlet.

Multiple data types in a single stream
--------------------------------------

I want to transmit multiple data types (e.g. floats, ints) at once.
What is the best way to do that?

The simplest way is to use a channel format that can hold all numbers that you
want to represent and concatenate your data into a vector of that type -- the
:cpp:enumerator:`cft_double64` format can store integers up to 53 bit, so it
will hold virtually any numeric values that you want to store.

It is also possible to transmit raw structs, but note that this is generally
unsafe and non-portable (e.g., different compilers insert varying amount of
padding between struct elements; also on platforms with different endianness
your data will be garbled).
An exception to this is sending numpy structs with explicitely set endianness
for all fields.

In principle you can also send multiple streams and use the same time stamp
when sending the samples, but that will require some extra complexity at the
receiving that is rarely worth the effort.

Stream data from a new hardware device
---------------------------------------

I want to make an LSL driver for a piece of hardware.
What is the fastest way to do that?

If a quick-and-dirty solution is fine, then the best way is to take one of the
example programs for your favorite language and extend it as needed.

If you want a graphical user interface and you know C++ and are on Windows,
you can copy one of the applications in the LSL distribution and adapt it as
needed.

See also: :doc:`../dev/app_dev`.

Timestamp accuracy
------------------

I am making a driver for a piece of hardware and want to make sure that my time
stamps are accurate.
How to do that?

If your data comes from a separate device your samples will generally be a few
milliseconds old.
If you know or have measured this delay, you can correct for it by submitting
the time stamp as
:cpp:expr:`lsl_local_clock()-my_sample_age`
when pushing a sample.

However, it is strongly recommended to log any constant offset (here:
:cpp:expr:`my_sample_age`) in the meta-data of the stream, otherwise it can be
hard to later reconstruct what value was used, especially if it is occasionally
revised.

Aside from a delay, your time stamps will also have a jitter due to
OS multi-tasking and buffering).

It is difficult to smooth the jitter in real time correctly without introducing
inadvertent clock drift and therefore it is recommended to submit non-smoothed
time stamps and leave it to the receiver to smooth them if needed.

In particular, when you analyze the data offline (e.g., in MATLAB or Python),
the XDF importer can do a much better job at linearizing the jitter post-hoc.

Using device timestamps
-----------------------

My hardware can produce time stamps of its own.
Should I pass them into LSL?

Usually the answer is no -- the preferred way is to either leave it to LSL's
:cpp:func:`~lsl::stream_outlet::push_sample()` or
:cpp:func:`~lsl::stream_outlet::push_chunk()` functions to time-stamp the data
(easiest), or to call the
:cpp:func:`lsl_local_clock()` function to read out the LSL clock, and then pass
that in, either unmodified or with a constant delay subtracted
(if you know the delay of your hardware).

The only exception is if you have multiple pieces of hardware, all of which
have access to the same high-precision clock, and you want to use that clock
instead of the LSL clock (if the millisecond precision provided by LSL is not
enough for your needs, e.g., demanding physics experiments), and you know
exactly what you are doing.
If you have any doubt on how you would use your own clock to synchronize
multiple pieces of hardware after you've recorded the data, don't use them.

High sampling rates
-------------------

I am transferring data at high sampling rate or bandwidth.
What is the most efficient way to do this?

When sending big data, it usually doesn't matter how you send it (via
:cpp:func:`~lsl::stream_outlet::push_sample()` or
:cpp:func:`~lsl::stream_outlet::push_chunk()`,
since the bottleneck at high bandwidth will typically be the operating system's
network stack.

For small sample sizes (few channels) and high sampling rates, consider pushing
the data in chunks to avoid forcing frequent OS calls and network transmission.
You can do this by either setting a chunk size when creating the outlet, or by
using :cpp:func:`~lsl::stream_outlet::push_chunk()` instead of :cpp:func:`~lsl::stream_outlet::push_sample()`,
or by setting the pushthrough flag in
:cpp:func:`~lsl::stream_outlet::push_sample()` to false for every sample except
the last one in a batch.

Also, if you have a large number of channels (e.g., transferring image data),
make sure that the data type that you pass to the push function corresponds to
the data type of the stream, otherwise you pay extra for type casting.

When receiving data at very high rate (100KHz+) or bandwidth (20MBps+), it is
faster to avoid the :cpp:func:`~lsl::stream_inlet::pull_chunk` functions and
instead use :cpp:func:`~lsl::stream_inlet::pull_chunk_multiplexed` with a
pre-allocated buffer.

Make sure that you use a recent version of liblsl (1.10 or later offers a
faster network protocol) at both the sender and the receiver.

Chunk sizes
-----------

My hardware supports different block/chunk sizes.
Which one is best for use with LSL?

The chunk size trades off latency vs. network overhead, so we suggest to allow
the user to override the value if desired.
A good range for the default value is between 5-30 milliseconds of data
(resulting in an average latency that is between 2.5-15 ms and an update rate
between 200-30 Hz).

Shorter chunks make sense in very low-latency control settings, though note
that chunks that comprise only a few bytes of data waste some network bandwidth
due to the fixed Ethernet packet overhead.

Longer chunks can also be used (any duration is permitted, e.g. for sporadic
data logging activities), although the longer the chunks are the harder it
becomes to perform sample-accurate real-time time-synchronization
(specifically, removing the jitter in the chunk time stamps):
the longest chunks that can be synchronized in real time would be around 100ms
in typical settings.

.. _faqmultimatch:

Multiple streams match a resolve query
-------------------------------------- 

I am getting more than one matching stream in my resolve query.
What is the best way to handle this?

You either have to rename one of your streams (if the software that provides
them allows you to do that), or you can make the query more specific.

For instance, instead of ``type='EEG'`` you could use e.g.,

- ``name='Cognionics Quick-20'`` (if that's the name of the stream),
- specify the hostname of the computer from which you want to read, as in
  ``name='Cognionics Quick-20' and hostname='My-PC001'``
  (assuming that this is your hostname)
- use more specific queries, e.g. ``type='EEG' and serial_number='ABCDEF'``

You can find out the names of the streams and of the computers that they run on
using the `LabRecorder <https://github.com/labstreaminglayer/App-LabRecorder>`_
(it will list them in the format ``streamname (hostname)`` -- keep in mind that
this is just how the recorder prints it, the ``(hostname)`` part is of course
not baked into the stream name).

As the developer of the software, a good way is to warn the user that their
query was ambiguous (so they can address it), and inform them that you are
using the last-created stream that matches the query.

This would be the stream with the highest value for the
:cpp:func:`~lsl::stream_info::created_at()` property (they come back unordered
from the resolve function call).

You could also point them to this FAQ entry on how they can make their query
more specific (:ref:`permalink <faqmultimatch>`).
