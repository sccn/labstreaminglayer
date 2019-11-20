User's Guide
############

Basic Operation
***************

An effective use of LSL requires there to be at least one application streaming data and at least one application receiving data. The stream source, also called an "Outlet", advertises itself on the network. The receiver resolves the advertised stream and creates a connection to it, also called an "Inlet". For each Inlet, the Outlet buffers data and then the next N samples are transmitted from that buffer to the inlet application when the inlet requests it.

Stream advertisement and data transmission all happen using networking protocols. The networking in LSL works as follows. The only active participants in LSL networking are the outlet objects, the inlet objects, as well as calls to a resolve function (these are all implemented in the liblsl library). Most details of the communication are configurable, so in the following only the default behavior is explained for conciseness.

Outlets
=======
An outlet may use either IPv4, or IPv6, or both IP stacks in parallel. In the latter case some of the sockets and threads are duplicated.

The main outlet class is :class:`lsl::stream_outlet`.

UDP Service Discovery
---------------------
An outlet creates a group of UDP sockets on which it listens for incoming content-based queries. Such queries are used to find a stream of interest that has the desired meta-data (e.g., a particular content type or number of channels). An outlet matches each inbound query to its stream's meta-data and responds only in case of a match. Repeated queries are served by a query cache for efficiency.

In particular, outlets listen via UDP on the multicast port (16571) for broadcast and multicast queries. Multiple sockets are created for this purpose, each of which listens on a different multicast address; these include both IPv4 and IPv6 addresses of the desired scope (for robustness to network conditions). The sockets are served from a single thread using asynchronous I/O for efficiency. While this still sounds like a lot of overhead, note that this thread is in waiting state for most of the time.

In addition, outlets create a single regular (unicast) UDP socket that listens for content queries on a free port in the port range 16572-16604. This is a fallback in case the broadcast/multicast service discovery is disabled. This socket not only handles content queries but also responds to time estimation packets (used by inlets to estimate clock synchronization when a transmission is ongoing).


TCP Data Transmission
---------------------
In addition each outlet creates a TCP server socket on a free port in the port range 16572-16604 to accept actual data transmission requests. There are two types of transmission requests: a request for streaming data (such a connection would be established when an inlet is used to pull samples from a particular provider) and a request for meta-data (such a connection would be established when an inlet is used to retrieve the full meta-data of a stream). TCP servers can also in principle handle service discovery, but are not used for this purpose due to the relative inefficiency of this.

An outlet can handle an arbitrary number of parallel connections to serve any number of listeners.

Resolve Operations
==================
When a client resolves a stream with desired properties on the lab network, it issues a resolve operation. A resolve operation temporarily opens a range of UDP sockets through which queries are sent to the broadcast, multicast or unicast addresses that are configured as active. It also opens a UDP socket to receive result packets on a free port. The resolve operation emits a packet across each channel in a brief burst and waits for responses, then sends the next burst. This is repeated until the required conditions are fulfilled (e.g., service was found, timeout, etc.).

Inlets
======
An inlet, when created, initially does not create any sockets. Sockets are created as needed for the following purposes:

* When a transmission of streaming data is started by calling pull\_sample() or open\_stream(), a TCP connection is established to the outlet in question and if successful, data is received over this connection until it breaks off or is explicitly terminated.
* If the XML meta-data of the inlet is requested, another TCP connection is established which persists until the meta-data has been transferred from the outlet.
* When the inlet is used to estimate time-correction values (as the recorder program does), a UDP socket is opened which periodically (every few seconds) exchanges a brief series of packets with the outlet's unicast UDP socket.
* If the connection to the outlet breaks off or is otherwise unsuccessful (for example due to a computer crash at the other end), and if the outlet was "recoverable", a resolve operation will be periodically scheduled every few seconds until the outlet in question is found again or the inlet is destroyed, or the active transmission is stopped.

Clock synchronization
---------------------

Here we talk about important functions like the local clock
(:func:`lsl_local_clock`), a function to query a time offset
(:func:`lsl_time_correction_ex`) and a function to get the library version used
by the loaded library (:func:`lsl_library_version`).
