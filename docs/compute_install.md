## Compute node install

1. Download the [Arch Linux
   installer](https://alpinelinux.org/downloads/) and boot it.
1. If the node uses wifi, bring it up with the following commands:
    1. `ip addr` to find the wireless interface (it will probably
       begin with `wlp`)
    1. `wpa_passphrase ESSID WPA_PASSWD > /etc/wpa_supplicant/w.conf`
       to generate a wpa_supplicant configuration file. This should
       work unless you have a very interesting WiFi setup (and in that
       case, you likely know what your conf file should look like and
       can manually create it)
    1. `wpa_supplicant -B -i IFACE -c /etc/wpa_supplicant/w.conf` to
       attach to WiFi
    1. `dhcpcd IFACE` to obtain an IP address. This may take a few
       seconds; run `ip addr` to watch for the address attaching to
       the interface
1. Run `'curl -O CONTROL_NODE_IP/compute-install'` to fetch the
   compute node install script from your control node
1. Run `'/bin/bash ./compute-setup CONTROL_NODE_IP IFACE [ESSID WPA_PASSWD]'`
    * `IFACE` is the interface you wish to set up during the install
    * `ESSID` is the wireless network you with to connect to
    * `WPA_PASSWD` is the WPA passphrase for network `ESSID`
    * `ESSID` and `WPA_PASSWD` are not needed if you are using a wired
      connection, or if you followed the above procedure for WiFi
      configuration
1. Answer the questions the installer asks. It will handle the rest

After the installer reboots, login as root and run

`/bin/bash compute-setup`

To complete the Homefarm-specific portions of installation. After
this, the compute node is ready for Ansible to take over its
configuration management. You can test that everything is working by
running `'ansible -m ping NODE_NAME'` from the control node.

