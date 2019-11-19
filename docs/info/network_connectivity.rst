.. role:: cmd(code)
   :language: bash

Network Troubleshooting
#######################

If a computer cannot see another computer's streams, the issue is usually the firewall on one (or both) of the computers. However, if you are working with untested client programs it is possible that a stream is not visible just because the program has a bug (instead of due to a networking error between two machines). To test such a case, confirm that you are also unable to transmit data using the programs labstreaminglayer/LSL/liblsl/bin/SendData and labstreaminglayer/LSL/liblsl/bin/ReceiveData, respectively. Note that these programs take some console input that must be typed in correctly (this is easy to test on a single computer).

To test whether the firewall is at issue, turn off both any personal firewall that you may have enabled, and then also turn off the Windows default firewall for the home or work network (if your network is declared home/work). As long as you are behind a router in a non-public network this should be safe.

To turn off the Windows firewall, go to Start Menu / Control Panel / Windows Firewall / Turn Windows Firewall on or off (on the side panel) and then switch the Home or work (private) firewall to off as in the below screen shot. Do **not** turn off the public firewall, especially if you are on a laptop.

.. image:: ../images/firewall-turnoff.png

Do this on both computers. Note that your home or work network might accidentally be declared as public network: if this is the case your firewall status next to "Home or work (private) networks" will be listed as "Not Connected" and instead your current connection will show up under "Public networks" as in the below screen shot. You will want to correct this.

.. image:: ../images/firewall-badconfig.png

Keep in mind that a public wifi such as a campus network or coffee shop should always stay under public networks -- you cannot safely disable the firewall for such a network, and therefore cannot safely use LSL on a public wifi (the campus network in the picture is actually a bad example for this switchover; it shall stand here for a safe work network). A password-protected or wired home/work network should instead be placed under the home or work category, by going to Start Menu / Control Panel / Network and Sharing Center. Under "View your active networks" you should see your current network, incorrectly labeled as "public network" as in the following screen shot.

.. image:: ../images/network-reconfig-a.png

Click on the public network and switch it to either work or home network. Note that you may have to do this on both computers.

If you can now see streams across computers, you have found the root cause. You might be able to re-enable your private-facing firewall and instead add a rule to your firewall that allows your client programs through the network (this can be done post-hoc in the firewall settings under "Allow a program or feature through Windows Firewall"). Most personal firewalls also allow you to set up per-program rules.

Another possible (although rare) reason is when you have multiple (perhaps virtual) network adapters, and the primary network adapter is not the one that can communicate with other machines. This can happen if you have a virtual machine monitor (e.g., VirtualBox) installed and configured in an unfortunate way. If this could be the case, you can test whether this is the reason by temporarily disabling the offending network adapter and rerunning the LSL check.

It can also be the case that if the proper adapter is not set as the default adapter, your LSL stream will not be broadcast to the network. In order to set an adapter as default in Windows, open up 'Control Panel->Network and Internet->Network Connections'. Hit 'Alt' to bring up the menu and select 'Advanced->Advanced Settings...'. This will bring up a dialog with the available adapters listed at the top. Move the desired adapter to the top of the list (drag and drop). You will need administrator privileges to do this.

.. image:: http://sccn.ucsd.edu/images/advanced_network_settings.png

If you still have connection problems your router might be configured to disable or block certain features or ports between computers. The features that are required by LSL to work in its default settings are UDP broadcasts or multi-cast on port 16571, as well as incoming TCP and UDP connections on ports 16572-16604 (although the upper ranges are only needed if you have sufficiently many LSL applications open on a single machine).

Customizing Network Features of LSL
###################################
All network features used by LSL clients (such as the ports) can be customized using an appropriately-placed configuration file. You can find a better summary of the underlying operational principles of LSL at the BasicOperation page.

Configuration File Locations
****************************
There are four possible locations where such a config file will be found by the library (liblsl):

* `/etc/lsl_api/lsl_api.cfg` (or `C:\etc\lsl_api\lsl_api.cfg` on Windows).
    * This is a global directory that is visible to all applications from all users on a given computer. It could, for example, be mounted from a remote location to have consistent settings.
* `~/lsl_api/lsl_api.cfg` (or `C:\Users\username\lsl_api\lsl_api.cfg` on Windows 7, `C:\Documents and Settings\username\lsl_api\lsl_api.cfg` on WinXP, and so on).
    * This is a user-specific directory that is visible for all applications of that user. No administrator rights are usually necessary to edit it.
* `lsl_api.cfg`
    * This is a program-specific location: the file needs to be in the working directory of the program (for example right next to the binary). This allows to customize LSL behavior on a program-by-program basis.
* starting with liblsl 1.13: the file specified in the environment variable `LSLAPICFG`
    * This is a shell-specific location. On Linux / OS X you can set the env variable either before the program invocation (`LSLAPICFG=/tmp/specialconf1.cfg ./LabRecorder`) or as an export (`export LSLAPICFG=/tmp/specialconf1.cfg`) to apply it to all programs started afterwards from this shell.

For the above settings, the more local settings files have the higher precedence, so a program-specific file overrides a user-specific file, which overrides the global file.

Configuration File Contents
***************************

The configuration file is formatted like a Windows .ini file. The following section contains the default settings of LSL that can be pasted into a file as-is, although it is usually a good idea to specify only the subset of parameters that you would like to override (to allow for future corrections to the default settings).

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
To change just the port range to, say 3051 - 3068, create a config file with the following content:

.. code:: bash

  [ports]
  MulticastPort = 3051
  BasePort = 3052
  PortRange = 16

This type of change would only be necessary if you can move LSL to a port range that is allowed through or forwarded by the router or firewall (or the administrator).

Changing the multicast scope
----------------------------
Under some circumstances your recording environment might include a large number of routers. Service discovery between routers is a case that is not handled particularly well by current network installations (it requires correct company-wide multicast settings), but in cases where it works, you can expand or contract the scope within which two machines will see each other's streams. The boundaries of these scopes are defined by the network administrators, but they have the common names "machine", "link", "site", "organization", and "global". The default scope used by LSL is "site". To change it to "organization", use a config file like the following one:

.. code:: bash

  [multicast]
  ResolveScope = organization

In some cases it can also be helpful to reduce the scope to "link" (which is the local router), for example when you have many concurrent recording operations that you would like to generally separate from each other (some one experimenter should not see the others' streams). Usually this is not necessary because between-router multicast is often not configured properly anyway.

Note that under the hood the multicast scopes are implemented by sets of multicast addresses (which have the scope encoded in their bitmask). Independently of the scope you can customize the addresses themselves, for example to adhere to local administrative rules. See the full config file for the relevant variable names.

Defining the Local Laboratory
-----------------------------
It is possible to define what constitutes the local laboratory network in a very fine-grained manner, if necessary (for example if one router was shared between 10 labs, each of which involves a number of machines, or if a single recording operation is coordinated across the internet between countries).

There are two mechanisms for this. The KnownPeers setting allows to explicitly list the IP addresses or hostnames of the involved machines. The following file contains an example:

.. code:: bash

  [lab]
  KnownPeers = {192.168.1.17, 137.243.177.26, testing.ucsd.edu}

With this setting any type of service discovery issues due to router configuration can be worked around. Note that at the same time you might want to disable the multicast discovery by restricting the ResolveScope to machine (the local machine) if the goal is to prevent interference.

The other mechanism does not involve the physical machines but is a purely logical partitioning of the network into separate and independent recording environments. This is accomplished by assigning a non-default value to the SessionID variable. You only ever see streams hosted by clients that have the same SessionID setting. Below is an example.

.. code:: bash

  [lab]
  SessionID = lab-001b

This way, you can assign a different session id per machine, or per user, or per application to bypass any sort of unwanted stream visibility between concurrent recording operations. Note, that the SessionID is not a security feature, however. You may still be able to intercept packets involved in a session that is not yours.

Security
========
Transmission between computers is unencrypted in LSL under the assumption that experiments involving sensitive data take place in a protected network environment. If you do not trust your network, the best way to establish such an environment by setting up a Virtual Private Network (VPN), which works even across the internet.