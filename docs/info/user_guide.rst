User's Guide
############

Basic Operation
***************

An effective use of LSL requires there to be at least one application streaming data and at least one application receiving data. The stream source, also called an "Outlet", advertises itself on the network. The receiver resolves the advertised stream and creates a connection to it, also called an "Inlet". For each Inlet, the Outlet buffers data and then the next N samples are transmitted from that buffer to the inlet application when the inlet requests it.

All of this is implemented in liblsl, the library that every LSL application and binding uses:

* **Discovery.** An outlet answers queries for its stream over UDP (multicast, broadcast and
  unicast). A resolve operation sends such queries, e.g. "all streams with type EEG", and collects
  the descriptions of the matching streams.
* **Data.** An inlet connects to the outlet over TCP, receives the stream's samples into its
  buffer, and fetches the full metadata on request.
* **Clock offsets.** When asked for time correction (as a recorder does), the inlet measures the
  offset between the two computers' clocks every few seconds with short UDP exchanges; see
  :doc:`time_synchronization`.
* **Recovery.** If the connection breaks off, for example because the sending program or
  computer restarted, the inlet finds the stream again and reconnects, as long as the stream's
  ``source_id`` identifies it uniquely.

The network ports and settings involved are in :doc:`network-connectivity` and
:doc:`lslapicfg`. liblsl's documentation describes each mechanism in detail, with the exact
messages, ports and timings: :liblsl:`How liblsl works <internals/overview.html>`.
