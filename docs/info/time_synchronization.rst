:orphan:

Time Synchronization
********************

LSL does not change your data's timestamps by default, but it records everything needed to
synchronize streams from different devices and computers:

1. **A timestamp for each sample** (or chunk), taken from the sending computer's local clock
   (``lsl_local_clock()``). This is a monotonic clock that counts seconds from an arbitrary
   starting point (often the time the computer booted); it has no relation to the time of day.
2. **Clock offsets** between the sending and the receiving computer, measured every few seconds
   by exchanging short UDP packets, similar to the Network Time Protocol (NTP). Applications that
   want them, such as a recorder, call ``time_correction()`` on their inlet.

How liblsl measures the offsets, how accurate they are, the ways to turn them into synchronized
timestamps and how its built-in smoothing works are described in liblsl's
:liblsl:`time synchronization <internals/time_sync.html>` page. This page is about getting
synchronized data in practice.

Recording: synchronize at import
================================

For data that is analyzed afterwards, record everything and synchronize when loading the file.
`LabRecorder <https://github.com/labstreaminglayer/App-LabRecorder>`__ stores the raw
timestamps and all clock offset measurements of every stream in the XDF file. The XDF importers
(`pyxdf <https://github.com/xdf-modules/pyxdf>`__,
`xdf-Matlab <https://github.com/xdf-modules/xdf-Matlab>`__, and the tools built on them such as
MNE-Python and EEGLAB) then:

* fit a straight line through each stream's clock offsets (assuming a constant clock drift) and
  use it to map the stream's timestamps onto the recording computer's clock, and
* for streams with a regular sampling rate, remove the jitter in the timestamps: they split the
  stream at interruptions (data loss) and, for each uninterrupted segment, fit a line between
  sample index and timestamp and recompute every timestamp from it.

Because the raw data is kept, a different mapping can be chosen later. Please use these tools to
record and import data where possible.

Online processing
=================

Many online applications don't need synchronization at all: what they need is low latency, so
they should use small chunks and process data as soon as it arrives. Some do need synchronized
timestamps, for example event-related processing (P300 or SSVEP brain-computer interfaces),
where the time of an event is used to cut out the neural data. Then either:

* set the inlet's post-processing flags (``proc_clocksync`` to add the latest clock offset,
  ``proc_dejitter`` to smooth the timestamps of regularly sampled streams, or ``proc_ALL``), see
  :cpp:enum:`lsl_processing_options_t`; or
* call ``time_correction()`` yourself and add its result to the timestamps of that inlet.

Adding the latest offset is usually enough; the remaining error is small compared to the jitter
of the raw timestamps, which ``proc_dejitter`` removes. Its smoothing settles within a minute or
two (see :liblsl:`dejitter <internals/time_sync.html#post-processing>` for how to tune it).

Manual Synchronization With Non-LSL Clocks
==========================================

In general, it is not possible to synchronize LSL streams with non-LSL clocks (e.g., wall clock, UNIX time, device without an LSL integration) unless there is a separate solution for this.

The clock offset UDP stream described above used by LSL to synchronize streams from different computers is one such solution. This could be reproduced for non-LSL streams but it is perhaps not the most straightforward solution.

The most straightforward solution, which seems to be the most common, is to use hardware. For example, a common signal such as a digital pulse can be fed to an LSL-integrated device and to the non-LSL system, then an offline analysis of the two files can align the data sources via cross-correlation. However, a hardware solution is not always possible, especially in mobile experiments.

The next most straightforward solution is to create a map between LSL time and the *other* clock, and this is probably most easily done in software by creating a simple LSL integration for that other clock. In this application, the *other* clock and the LSL clock are read at approximately the same time (i.e., one line of code after the other) and the time of the other clock is sent as the data payload and the coincident LSL clock is sent as the time stamp in the call to ``push_sample``. Subsequent offline analysis can load these clock-LSL pairs and create a mapping between the two. The most common mapping would be via a linear regression and that is probably sufficient in most cases (i.e., where the clock drift is consistent). Piecewise or moving-window mappings will be more accurate but also slower to calculate.

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

To see the synchronization capabilities of LSL in action, see https://sccn.ucsd.edu/download/mgrivich/LSL_Validation.html.
