# Compute node install

## Arch install

1. Download the [Arch Linux
   installer](https://alpinelinux.org/downloads/) and boot it.
1. If the node uses wifi, bring it up with the following commands:
    1. `'ip addr'` to find the wireless interface (it will probably
       begin with `wlp`)
    1. `'wpa_passphrase ESSID WPA_PASSWD > /etc/wpa_supplicant/w.conf'`
       to generate a wpa_supplicant configuration file. This should
       work unless you have a very interesting WiFi setup (and in that
       case, you likely know what your conf file should look like and
       can manually create it)
    1. `'wpa_supplicant -B -i IFACE -c /etc/wpa_supplicant/w.conf'` to
       attach to WiFi
    1. `'dhcpcd IFACE'` to obtain an IP address. This may take a few
       seconds to complete.
1. Run `'curl -O CONTROL_NODE_IP/node-install'` to fetch the
   compute node install script from your control node
1. Run `'/bin/bash ./node-install CONTROL_NODE_IP IFACE [ESSID WPA_PASSWD]'`
    * `IFACE` is the interface you wish to set up during the install
    * `ESSID` and `WPA_PASSWD` are not needed if you are using a wired
      connection, or if you followed the above procedure for WiFi
      configuration
        * `ESSID` is the wireless network you with to connect to
        * `WPA_PASSWD` is the WPA passphrase for network `ESSID`
1. Answer the questions the installer asks. It will handle the rest

## Homefarm setup

After the reboot, login as root and run `'/bin/bash node-setup'` to
complete the Homefarm-specific portions of installation. When
`node-setup` completes, the node is ready for Homefarm to take over
its management.

You can test that everything is working by running `'ansible -m ping
NODE_NAME'` from the control node.

Repeat the install-and-setup procedure for all other nodes which need
to be installed.

## Putting nodes into service

These steps happen on the controller.

1. Ensure that all the nodes you've added have entries in `farm.cfg`.
1. For each node, create (or symlink if the new node will be sharing a
   configuration with an existing node) a config file in the
   `/homefarm/nodes` directory. The file(s) should be named
   `[HOSTNAME].yml`.
1. Run `'farmctl node-init` to handle initial BOINC

