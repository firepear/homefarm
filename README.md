# homefarm
Tools for deploying and managing a BOINC compute farm using Ansible, Raspbian, and Alpine Linux.

Homefarm makes a few assumptions:

* You have a Raspberry Pi, to act as the control node.
* You have one or more machines capable of running Alpine Linux, to
  act as the compute nodes.
* You are comfortable doing basic Linux installs. Homefarm takes
  care of just about everything beyond the core install and network
  configuration, but getting to that point is on you.
* You are on a private network, because an SSH key with no passphrase
  will be autogenerated for Ansible's use.

# Setting up your farm

## Control node setup

1. Image an SD card with [Raspbian
   Lite](https://www.raspberrypi.org/downloads/raspbian/), boot the
   Pi, and do any initial network/locale/etc configuration that you
   wish (recommended: enable the ssh daemon via
   `raspi-config`). Reboot if necessary.
1. Login as the default user and run `'sudo apt-get --yes install git'`
1. Run `'git clone https://github.com/firepear/homefarm.git'`
1. Run `'cd homefarm'`
1. Run `'sudo ./control-setup'`. The Pi will reboot after this
   script completes.
1. Login after reboot and edit `farm.cfg`, which is our Ansible
   inventory. Change `node00` in the `[control]` stanza to match the
   name you've given the controller (AKA your Raspberry Pi). Then add
   the names of all the machines you'll be setting up as compute nodes
   to the `[compute]` stanza.
1. Make sure the names and IP addresses of these machines are in your
   controller's `/etc/hosts` file.

The controller is now ready.

## Compute node setup

Before installing a new compute node, login to the control node and
run `'cd ~/homefarm && ./bin/serve'`. This will start a Python webserver
to make available the `compute-setup` script and data needed by that
script. When done with installs, terminate the server with `Ctrl-C`.

1. Download [Alpine Linux
   Standard](https://alpinelinux.org/downloads/) and install it.
    * The Alpine installer will handle WiFi properly on install, but
      will not enable `wpa_supplicant` for subsequent boots, so before
      rebooting run `'rc-update add wpa_supplicant boot'`.
1. Fetch the compute node setup script from your control node by
   running `'wget [CONTROL_NODE_IP]:8000/compute-setup'`
