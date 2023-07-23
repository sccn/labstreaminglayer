:orphan:

Time Synchronization
********************

General Information
###################

Introduction
====================================
LSL does not perform synchronization by default, but it does provide all of the information required for synchronization. Synchronization information includes timestamps for each sample (or chunk of samples) and clock offset measurements between the stream origin (outlet) and the stream consumer (inlet). Detailed descriptions of the timestamps and the clock offsets can be found below.

File-recording applications should store all synchronization information to disk. File importers should then use the synchronization information from the entire span of the recording to perform synchronization. `LabRecorder <https://github.com/labstreaminglayer/App-LabRecorder>`_ handles storage of the synchronization information in the XDF file for you. The official XDF importers (pyxdf or xdf-Matlab), whether used directly or integrated into a tool like MNE or EEGLAB, use the synchronization information in the XDF file and perform stream synchronization upon file import. Please use these tools for your data storage and import if possible.

Online applications often do not require synchronization. Typically, what's actually needed is low latency; the receiving application should use small chunk sizes and process data for feedback as soon as possible.
However, there are use-cases requiring online synchronization such as event-triggered processing like P300- and SSVEP-based BCIs, because the time of the event is used to segment the neural data. When online synchronization is required, please set the `inlet's postprocessing flags appropriately <https://github.com/sccn/liblsl/blob/0b35dba3464c22bc707fef88d18483c597519e81/include/lsl/inlet.h#L126-L142>`_.

Synchronization Information
===========================
The built-in time synchronization in LSL relies on two pieces of data that are being collected alongside with the actual sample data:

1. A timestamp for each sample that is read from a local monotonic clock of the computer. The method for obtaining the timestamp value can be found `here <https://github.com/sccn/liblsl/blob/6ca188c266c21f7228dc67077303fa6abaf2e8be/src/common.cpp#L20>`_. As of this writing, the clock is `std::chrono::steady_clock <https://en.cppreference.com/w/cpp/chrono/steady_clock>`_. From `this S/O answer <https://stackoverflow.com/a/45891628>`_, "`steady_clock` is like a stopwatch. It is great for timing how long something takes. But it can't tell you the time of day. It has no relationship whatsoever to a human calendar on any platform. On macOS `steady_clock` it is a count of nanoseconds since the computer booted."
2. Out-out-of-band clock synchronization information that is transmitted along with each data stream to the receiving computer and collected by those applications that are interested in synchronization features (a recording program, such as LabRecorder, for instance). This clock synchronization information consists of measurements of the momentary offset between the two involved clocks that are made at periodic intervals (every few seconds).

Detailed Information
####################

Clock Offset Measurement
========================
The clock offsets are measured using a protocol that is similar to the Network Time Protocol. Each offset measurement involves a brief sequence of n UDP packet exchanges (n=8 by default) between the two involved computers. Each packet exchange yields a) an estimate of the round-trip-time (RTT) between the two computers, and b) an estimate of the clock offset (OFS) at the time of the measurement with the round-trip-time factored out. The final offset estimate for the given measurement is the one offset value out of the n measured ones for which the associated RTT value was minimal (to attain a high chance of using only estimates that were taken under nominal packet transport conditions and with minimal effect of transmission delays). The process of repeated measurement and selection is called the “Clock Filter” algorithm in NTP.

Network Packet Exchange
=======================
The packet exchange for obtaining a single raw OFS and RTT measurement works as follows. Suppose Alice initiates a query of Bob’s clock offset relative to her clock. Alice sends a packet P1 containing the timestamp t0 of when the packet was submitted to the network stack. Bob, upon receiving the packet, appends the time stamp t1 of when the packet was received at his end of the network. Bob then returns a packet P2 that contains t0, t1, and a timestamp t2 of when the return packet was submitted. The transmission is completed with Alice receiving P2 and taking the timestamp t3 of the time of receipt. The time duration of Bob’s processing is given by t2 - t1 and the overall time of the process is t3 - t0. The RTT of the exchange is (t3-t0) - (t2-t1). The clock offset OFS is ((t1-t0) + (t2 - t3)) / 2.

Resulting Estimation Bias
=========================
The synchronization is correct if both the incoming and outgoing routes of the server have symmetrical nominal delay. If this delay differs, the synchronization has a systematic bias of half the difference between the forward and backward travel times. On a symmetric local area network, the travel time differences are a sum of random delays due to multi-threading, buffering or interruptions on one hand, and the systematic difference in the latency of the two involved network stacks. Since the clock filtering algorithm reduces the probability of the random effects on the estimates, the residual inaccuracy is dominated by the systematic difference between the latency of both network stacks (e.g. Linux vs. Windows), which can be expected to be reasonably well below a millisecond on modern hardware and operating systems (see also section Validation).

Synchronization Process (Offset Correction)
===========================================
Given a history of clock offset measurements between two computers, the timestamp of a remotely collected sample can be remapped into the local time domain to be comparable with all other available samples. In the simplest case this can be accomplished by adding the most recent clock offset value to each remotely collected timestamp. A more powerful approach would be to calculate a linear fit through the (perhaps noisy) clock offset measurements and use the resulting linear mapping to remap the timestamps, while an even more sophisticated approach might be to perform an outlier-resilient (robust) linear fit through the clock offsets to get a better linear mapping. The library itself does not perform any particular such mapping but instead leaves it to the user (i.e., the recipient of the data) to combine the history of offsets with the sample timestamps if desired.

Synchronization for Online Processing
-------------------------------------
Most online processing applications are only ever receiving a single stream, or do not require fine-grained time alignment so that no online synchronization is necessary at all. For those applications that do need synchronized time-stamps, it usually suffices to add the last clock offset to the time stamps for each inbound stream.

It is possible to average out the error in successive offset measurements to reduce it further, but it should be noted that this synchronization-related jitter is already small, and often the jitter in the raw time-stamp values even before offset correction is already at least 10x larger. These two sources of jitter can be cleanly addressed in a single post-processing step of the synchronized time stamps (see sections Time-Stamp Post-Processing (Dejitter) and Online Smoothing).

Synchronization in Multi-Stream Recordings
------------------------------------------
When data is recorded to disk, the reference recording program included with LSL (LabRecorder) will just collect all the available information, including time stamps and clock offsets for every remote stream and store it unmodified -- thus leaving it to the importer function to handle the time correction calculations post-hoc. This is to allow the user to employ their algorithm of choice even long after the data have been collected. The reference importer (load\_xdf) performs a linear fit through the clock offsets for each remote stream (thereby assuming a linear clock drift) and uses this linear mapping to remap given remotely collected timestamps.

Time-Stamp Post-Processing (Dejitter)
-------------------------------------
After the time series have been synchronized (i.e., the clock offset has been corrected), it is important to note that there will almost always be a jitter (e.g., Gaussian noise) in the time stamps, which is not due to the synchronization but because the time-stamping itself usually does not happen exactly in regular intervals but on a somewhat random schedule (dictated by the perils of the hardware, the driver, and the operating system). For milisecond-accurate multi-stream alignment, it is therefore necessary to remove this random jitter as well, which can be done by applying a trend-adjusted smoothing algorithm to it. Smoothing can be done either online at the time of data collection, or offline at data import time. If the data are analyzed post-hoc rather than online, it is always better to perform it at import time, since one can do a better job given all the available data than doing it incrementally as the data is being collected.

Smoothing At Import Time
------------------------
Besides correcting for the clock domain, the XDF importer will, by default, as the last step do a final re-calculation of the timestamps of all streams that have regular sampling rate. This is desirable since the actual time stamps of samples or of blocks of samples are typically subject to a small jitter. The calculation handles each stream independently and first checks if the time series contains any interruptions (i.e., data loss) using a generous threshold on the observed sample-to-sample intervals. For each uninterrupted segment it then calculates a linear fit between the index of each respective sample and its timestamp (thus assuming a constant but arbitrary effective sampling rate) and then re-calculates from it the time stamps of all samples based on their respective index.

Online Smoothing
----------------
To smooth the time stamps online, multiple algorithms can be used. The simplest one is double exponential smoothing, which is relatively easy to implement in an online data processing system, although it should be noted that during the first few minutes of operation (up to 5) the resulting time stamps will still have a considerable error (above 1 ms). The forgetting factors of this algorithm need to be set depending on the sampling rate of the data and the amplitude of the jitter in the raw stamps, and can require some tuning until the desired accuracy is reached. A better alternative is Recursive Least Squares (RLS), which has essentially optimal convergence behavior, although it will still take a minute or two of warmup until the jitter after smoothing reaches an acceptable level (<1ms) in realistic settings. To achieve this precision, the forget factor should be set such that a sample that is 30 seconds old will have an effective weighting of 1/2 (this depends on the sampling rate); one can also use 60 or as much as 120 seconds to further increase the precision -- however, too large values can fail to track sufficiently fast non-linear clock drift due to room or computer temperature changes (empirically, a half time of x seconds will be able to track clock rate fluctuations that change on the order of 10*x seconds or more slowly). This algorithm will also be built-in for optional use in a future version of liblsl. Other algorithms, such as QR-RLS and the Kalman filter can also be used and will perform similarly to RLS (note: some formulations of RLS have numerical difficulties, depending on the order of operations, and should not be used as they can 'blow up' after a few minutes of use).

Manual Synchronization With Non-LSL Clocks
==========================================

In general, it is not possible to synchronize LSL streams with non-LSL clocks (e.g., wall clock, UNIX time, device without an LSL integration) unless there is a separate solution for this.

The clock offset UDP stream described above used by LSL to synchronize streams from different computers is one such solution. This could be reproduced for non-LSL streams but it is perhaps not the most straightforward solution.

The most straightforward solution, which seems to be the most common, is to use hardware. For example, a common signal such as a digital pulse can be fed to an LSL-integrated device and to the non-LSL system, then an offline analysis of the two files can align the data sources via cross-correlation. However, a hardware solution is not always possible, especially in mobile experiments.

The next most straightforward solution is to create a map between LSL time and the _other_ clock, and this is probably most easily done in software by creating a simple LSL integration for that other clock. In this application, the _other_ clock and the LSL clock are read at approximately the same time (i.e., one line of code after the other) and the time of the other clock is sent as the data payload and the coincident LSL clock is sent as the time stamp in the call to `push_sample`. Subsequent offline analysis can load these clock-LSL pairs and create a mapping between the two. The most common mapping would be via a linear regression and that is probably sufficient in most cases (i.e., where the clock drift is consistent). Piecewise or moving-window mappings will be more accurate but also slower to calculate.

Note that the manual synchronization solutions described above only describe how to save data that will allow for offline synchronization during offline data analysis. This should satisfy most use cases. Online synchronization between the LSL clock and a non-LSL clock is still possible using the above software solution with a moving-window mapping (or exponential decay mapping) and setting the :cpp:enumerator:`proc_clocksync` or :cpp:enumerator:`proc_ALL` postprocessing flags at inlet creation time. Otherwise, you have to add the time offset returned by :cpp:func:`lsl::stream_inlet::time_correction()` to the timestamps to have them in your local domain.

Stream Header Synchronization Parameters
========================================
It is recommended that all LSL stream generators attach the following block to the header of each stream. The offset\_mean parameter is used to subtract known constant time lags from each stream. can\_drop\_samples is used to label a stream as having a steady frame rate, except for dropped samples. This is what you expect for video players and video recorders. The other parameters are for informational purposes or error estimation only.

.. code:: xml

  <desc>
    <synchronization>        # information about synchronization requirements
      <offset_mean>          # mean offset (seconds). This value should be subtracted from XDF timestamps before comparing streams. For local LSL generated events, this value is defined to be zero.
      <offset_rms>           # root-mean-square offset (seconds). Note that it is very rare for offset distributions to be Gaussian.
      <offset_median>        # median offset (seconds).
      <offset_5_centile>     # 95% of offsets are greater than this value (seconds)
      <offset_95_centile>    # 95% of offsets are less than this value (seconds)
      <can_drop_samples>     # whether the stream can have dropped samples (true/false). Typically true for video cameras and video displays and false otherwise.
    </synchronization>
  </desc>


Validation
==========

To see the synchronization capabilities of LSL in action, see http://sccn.ucsd.edu/~mgrivich/Synchronization.html and especially http://sccn.ucsd.edu/~mgrivich/LSL_Validation.html.