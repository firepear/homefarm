# homefarm
Tools for deploying and managing a BOINC compute farm using Ansible
and Arch Linux.

_WARNING: TREE IS CURRENTLY UNSTABLE. DO NOT INSTALL. RELEASE SOON._

If you have a pre-v0.13 Homefarm install, please see the [upgrade
doc](https://github.com/firepear/homefarm/blob/master/docs/upgrade-to-0.13.0.md).

Homefarm makes a few assumptions:

* A Raspberry Pi 3B/B+, to act as the control node.
* One or more machines capable of running Arch Linux, to act as the
  compute nodes.
* You are aware of your local network configuration, and have IPs to
  assign to the nodes.
* You're familiar with BOINC, projects, workunits, and so on.
* All nodes are on a private network -- an SSH key with no passphrase
  will be generated for Ansible's use, and the control node's default
  passwords will be left in place.

# Documentation

* Setting up a farm
    * [Control node install](https://github.com/firepear/homefarm/blob/master/docs/control_install.md)
    * [Compute node install](https://github.com/firepear/homefarm/blob/master/docs/compute_install.md)
    * [BOINC initialization](https://github.com/firepear/homefarm/blob/master/docs/boinc_setup.md)
* [Managing and maintaining your farm](https://github.com/firepear/homefarm/blob/master/docs/management_and_maintenance.md).

