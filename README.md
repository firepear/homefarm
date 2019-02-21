# homefarm
Tools for deploying and managing a BOINC compute farm using Ansible
and Arch Linux.

Homefarm makes it easier -- or at the least _faster_ -- to install,
reinstall, configure, and update all your BOINC crunchboxes. It also
makes your a better netizen: all your compute nodes will install and
update from a local repository that lives on the control node.

Homefarm makes a few assumptions:

* A Raspberry Pi 3B/B+, to act as the control node.
  * The Pi's OS is on a 32GB+ SD card
* One or more x86_64 machines capable of running Arch Linux, to act as
  the compute nodes.
  * These machines will be used for no other purpose, and it is okay
    to wipe their drives -- Homefarm does not do custom partitioning.
* You are aware of your local network configuration, and have IPs to
  assign to the nodes.
* All nodes are on a private network -- an SSH key with no passphrase
  will be generated for Ansible's use, and the control node's default
  passwords will be left in place.
* You're familiar with BOINC, projects, workunits, and so on.

# Documentation

* Setting up a farm
    * [Control node install](https://github.com/firepear/homefarm/blob/master/docs/control_install.md)
    * [Compute node install](https://github.com/firepear/homefarm/blob/master/docs/compute_install.md)
    * [BOINC initialization](https://github.com/firepear/homefarm/blob/master/docs/boinc_setup.md)
* [Managing and maintaining your farm](https://github.com/firepear/homefarm/blob/master/docs/management_and_maintenance.md).
* If you have a pre-v0.13 Homefarm install, please see the [upgrade
doc](https://github.com/firepear/homefarm/blob/master/docs/upgrade-to-0.13.0.md).

