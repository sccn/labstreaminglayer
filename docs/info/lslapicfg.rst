LSL configuration files
#######################

liblsl reads an optional configuration file, ``lsl_api.cfg``, that changes how it behaves on
the network: the ports it uses, which part of the network it searches for streams, a list of
known computers to query directly, and logging and timing settings. Applications don't need to
know about it.

The full reference, including where liblsl looks for the file, its syntax and every setting with
its default, is in the liblsl documentation: :liblsl:`Configuration (lsl_api.cfg) <guide/configuration.html>`.

A common example: telling every computer in a lab about the others (useful when multicast
discovery doesn't work on the network), and keeping two experiments on the same network apart:

.. code-block:: ini

   [lab]
   KnownPeers = {192.168.1.17, 192.168.1.18}
   SessionID = my-experiment

Put this file at ``~/lsl_api/lsl_api.cfg`` (or ``/etc/lsl_api/lsl_api.cfg`` for all users) on
every computer. Settings that affect discovery, such as the ports and ``SessionID``, must be
the same on all computers.
