LSL configuration files
=======================

The liblsl library can be configured with configuration files.

Configuration File Locations
----------------------------

There are four possible locations where such a config file will be found by the library (liblsl):

- :file:`/etc/lsl_api/lsl_api.cfg` (Unix)
  :file:`C:\etc\lsl_api\lsl_api.cfg` (Windows)
  This is a global directory that is visible to all applications from all users
  on a given computer.
- :file:`~/lsl_api/lsl_api.cfg` (Unix)
  :file:`%HOMEPATH%\lsl_api\lsl_api.cfg` (Windows)
  This is a user-specific directory that is visible for all applications of
  that user.
  No administrator rights are usually necessary to edit it.
- :file:`$PWD/lsl_api.cfg`
  This is a program-specific location: the file needs to be in the working
  directory of the program (for example right next to the binary).
  This allows to customize LSL behavior on a program-by-program basis.

.. versionadded:: 1.13
.. envvar:: LSLAPICFG

- the file specified in the environment variable :envvar:`LSLAPICFG`
  This is a shell-specific location.
  On Linux / OS X you can set the env variable either before the program
  invocation (:command:`LSLAPICFG=/tmp/specialconf1.cfg ./LabRecorder`) or as
  an export (:command:`export LSLAPICFG=/tmp/specialconf1.cfg`) to apply it to
  all programs started afterwards from this shell session.

For the above settings, the more local settings files have the higher
precedence, so a program-specific file overrides a user-specific file, which
overrides the global file.

Configuration File Contents
---------------------------

The configuration file is formatted like a Windows .ini file.

The following section contains the default settings of LSL that can be pasted
into a file as-is, although it is usually a good idea to specify only the
subset of parameters that you would like to override (to allow for future
corrections to the default settings).

.. code:: bash

    [ports]
    ; This port is used by machines to advertise and request streams.
    MulticastPort = 16571

    ; This is where the range of ports to serve data and service information begins (growing upwards according to the PortRange).
    BasePort = 16572

    ; Ports from the BasePort to BasePort+Portrange-1 are assigned to both TCP data ports (on the even ports, if the BasePort is odd)
    ; and UDP service ports (on odd ports, if BasePort is even); since these ports are occupied in pairs, there can effectively be
    ; PortRange/2 stream outlets coexisting on a single machine. A new outlet will occupy a successively higher pair of ports when
    ; lower ones are occupied. The number of coexistant outlets can be increased by increasing this number. However, note that if
    ; multicast and broadcast or all UDP transmission are disabled on some router, the peers will need to "manually" scan this range,
    ; which can be slow on such a network. Also note that, to communicate with external parties, the port range needs to be open in the
    ; respective firewall configurations.
    PortRange = 32

    ; How to treat IPv6: can be "disable" (then only v4 is used), or "allow" (then both are used side by side) or "force" (then only v6 is used).
    IPv6 = allow

    [multicast]
    ; The scope within which one's outlets and inlets are visible to each other. This can be machine (local to the machine),
    ; link (local to the subnet), site (local to the site as defined by local policy), organization (e.g., campus), or global.
    ; Always use only the smallest scope that works for your goals. This setting effectively merges the contents of
    ; MachineAdresses, LinkAddresses, SiteAddresses, OrganizationAddresses, and GlobalAddresses, and sets the packet
    ; TTL to one of the settings: 0, 1, 24, 32, or 255. If you share streams with remote collaborators, consider using the
    ; KnownPeers setting under [lab] (thus listing their machines directly, which is more likely to work than internet-scale
    ; multi-casting). Another possibility is to use the AddressesOverride and TTLOverride settings to avoid pulling in every
    ; site at intermediate scopes.
    ResolveScope = site

    ; These are the default address pools for VisibilityScope. The following lists of addresses are merged according
    ; to the VisibilityScope setting to yield the set of addresses considered for communication.
    ; Note that making an uninformed/unfortunate address choice can interfere with your site's operations.
    MachineAddresses = {FF31:113D:6FDD:2C17:A643:FFE2:1BD1:3CD2}
    LinkAddresses = {255.255.255.255, 224.0.0.183, FF02:113D:6FDD:2C17:A643:FFE2:1BD1:3CD2}
    SiteAddresses = {239.255.172.215, FF05:113D:6FDD:2C17:A643:FFE2:1BD1:3CD2}
    OrganizationAddresses = {239.192.172.215, FF08:113D:6FDD:2C17:A643:FFE2:1BD1:3CD2}
    GlobalAddresses = {}

    ; This allows you to override the addresses calculated by VisibilityScope. To communicate conveniently wth a remote party without negotiating
    ; the involved hostnames, you may choose a privately agreed-on multicast address of the appropriate scope here.
    AddressesOverride = {}

    ; This setting allows you to override the packet time-to-live setting. If you intend to use multicast with a custom address to conveniently
    ; communicate with a specific remote party, you may set this to a sufficiently high level (255 for international collaboration).
    TTLOverride = -1

    [lab]
    ; This setting mainly serves as a fallback in case that your network configuration does not permit multicast/broadcast communciation.
    ; By listing the names or IP addresses of your lab's machines here (both stream providers and stream users) and make the file available
    ; on all involved machines, you can bypass the need for multicasting. This setting can also be used to link a small collection of machines
    ; across the internet, provided that the firewall settings of each party permit communication (forward the BasePort to BasePort+PortRange ports).
    KnownPeers = {}

    ; This is the default "vanilla" session id; modify it to logically isolate your recording acitities from others within the scope.
    ; The session id should not be relied on as a "password" to hide one's data from unpriviledged users; use operating-system and
    ; network settings for this purpose. Note that you machine still gets to see some traffic from other activities if within the scope.
    SessionID = default

Changing the port ranges
------------------------

To change just the port range to, say 3051 - 3068, create a config file with
the following content:

.. code:: bash

  [ports]
  MulticastPort = 3051
  BasePort = 3052
  PortRange = 16

This type of change would only be necessary if you can move LSL to a port range
that is allowed through or forwarded by the router or firewall
(or the administrator).

Changing the multicast scope
----------------------------
Under some circumstances your recording environment might include a large
number of routers.
Service discovery between routers is a case that is not handled particularly
well by current network installations (it requires correct company-wide
multicast settings), but in cases where it works, you can expand or contract
the scope within which two machines will see each other's streams.

The boundaries of these scopes are defined by the network administrators, but
they have the common names `machine`, `link`, `site`, `organization`, and
`global`.

The default scope used by LSL is `site`.
To change it to `organization`, use a config file like the following one:

.. code:: bash

  [multicast]
  ResolveScope = organization

In some cases it can also be helpful to reduce the scope to `link`
(which is the local router), for example when you have many concurrent
recording operations that you would like to generally separate from each other
(some one experimenter should not see the others' streams).
In a local lab, the :ref:`lab.KnownPeers <lslapicfg_lab>` option is usually a
better choice, though.

Usually this is not necessary because between-router multicast is often not
configured properly anyway.

Note that under the hood the multicast scopes are implemented by sets of
multicast addresses (which have the scope encoded in their address).
Independently of the scope you can customize the addresses themselves, for
example to adhere to local administrative rules.
See the full config file for the relevant variable names.

.. _lslapicfg_lab:

Defining the Local Laboratory
-----------------------------
It is possible to define what constitutes the local laboratory network in a
very fine-grained manner, if necessary (for example if one router was shared
between 10 labs, each of which involves a number of machines, or if a single
recording operation is coordinated across the internet between countries).

There are two mechanisms for this.

The `KnownPeers` setting allows to explicitly list the IP addresses or
hostnames of the involved machines.

The following file contains an example:

.. code:: bash

  [lab]
  KnownPeers = {192.168.1.17, 137.243.177.26, testing.ucsd.edu}

With this setting any type of service discovery issues due to router
configuration can be worked around.
Note that at the same time you might want to disable the multicast discovery by
restricting the ResolveScope to machine (the local machine) if the goal is to
prevent interference.

The other mechanism does not involve the physical machines but is a purely
logical partitioning of the network into separate and independent recording
environments.
This is accomplished by assigning a non-default value to the SessionID option.
You only ever see streams hosted by clients that have the same SessionID.

Below is an example:

.. code:: bash

  [lab]
  SessionID = lab-001b

This way, you can assign a different session id per machine, or per user, or
per application to bypass any sort of unwanted stream visibility between
concurrent recording operations.
Note, that the SessionID is not a security feature, however.

You are still be able to intercept packets involved in a session that is not
yours.
