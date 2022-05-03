# Homefarm node install

## Conventions, standards, and cautions

- All nodes should be x86_64
- Compute nodes should be named `nodeNN...` (`node` followed by
  however many digits you would like)
- Storage nodes should be named `storNN...`
- Don't task a single node with compute and storage
- Task a Homefarm node with non-Homefarm tasks at your own risk
- The installer will wipe any storage devices in use by Homefarm
- Homefarm will only use a single storage device on a compute
  node, and will not use much of it. Go cheap and small.


## Boot Arch Linux

Download the [Arch Linux
installer](https://www.archlinux.org/download/) and boot it.

If the node uses wifi, bring it up with the following commands:

1. Do `ip addr` to find the wireless interface (it will probably
   begin with `wlp`)
1. `wpa_passphrase ESSID WPA_PASSWD > /etc/wpa_supplicant/w.conf` to
   generate a wpa_supplicant configuration file. This should work
   unless you have a very interesting WiFi setup (and in that case,
   you likely know what your conf file should look like and can
   manually create it)
1. `wpa_supplicant -B -i IFACE -c /etc/wpa_supplicant/w.conf` to
   attach to WiFi
1. `dhcpcd IFACE` to obtain an IP address. This may take a few
   seconds to complete.

Note for the next step: annoyingly, some versions of the Arch
installer see wireless interfaces as `wlan0` rather than their actual
name (e.g. `wlp8s0`). This is an issue because post-install, the
actual interface name will be used.

If you know the actual interface name, use it here, even though that
isn't the interface currently up.

If you don't, use `wlan0` for now, and run see the [fixes
doc](https://github.com/firepear/homefarm/blob/master/docs/fixes.md)
for instructions before moving on to the "Homefarm setup" portion of
this doc.

## Homefarm install

1. Run `curl -O CONTROL_NODE_IP:9099/node-install` to fetch the
   compute node install script from your control node
   * This is the only time you'll need to supply the port number when
     asked for the control node's IP
1. Run `/bin/bash ./node-install CONTROL_NODE_IP IFACE [ESSID WPA_PASSWD]`
   * `ESSID` and `WPA_PASSWD` are not needed if you are using a wired
     connection, or if you followed the above procedure for WiFi
     configuration
   * If you get DNS failures here, but you can ping by IP, run
     `systemctl disable --now systemd-resolved` then rerun
     `node-install`
1. Answer the questions the installer asks. It will handle the rest.
   After reboot, the node is ready for Homefarm to take over its
   management

You can test the inital install by running `'ssh farmer@NODENAME'`
from the controller. If you can login, then everything should be good
for the next steps.

Repeat the install-and-setup procedure for all other nodes which need
to be installed.

## Putting nodes into service

Once you have all nodes installed, return to the controller and
perform these steps.

- Ensure that all nodes you've brought up have entries in `farm.cfg`
- Create (or symlink if the new node will be sharing a configuration
  with an existing node) a config file in the `/homefarm/nodes`
  directory
  - The file(s) should be named `NODENAME.yml`
  - See the file `./files/node.yml` as an example, or copy it as a
    starting point

### Compute nodes

- Run `farmctl boinc-config` to handle initial BOINC configuration and
   some script setups.
- Run `farmctl project-sync` to attach the nodes to their projects,
   as defined in the `NODENAME.yml` files.

### Storage nodes

- Soon
