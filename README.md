# Homefarm

Tools for deploying and managing a BOINC compute farm using Ansible
and Arch Linux.

Homefarm makes it easier and faster to install, reinstall, configure,
and update all your BOINC crunchboxes. It also saves your bandwidth:
all your compute nodes will install and update from a local repository
that lives on the control node.

There are a few assumptions:

* One machine capable of running Docker, to host the controller
* One or more x86_64 machines capable of running Arch Linux, to become
  compute nodes
  * It's further assumed that these machines will be used for no other
    purpose, and it is okay to wipe their drives
* You are aware of your local network configuration, and have IPs to
  assign to the nodes.
* All nodes are on a private network -- an SSH key with no passphrase
  will be generated for Ansible's use
* You're familiar with BOINC, projects, workunits, and so on

# News

* 2020-01-05: v2.1.0: Added `status-once` subcmd (see
  [Management](https://github.com/firepear/homefarm/blob/master/docs/management.md)
  for more); enabled history for interactive sessions
* 2020-01-04: v2.0.1 is released. Fix for local repo issues due to
  Arch's migration to Zstd compression beginning
* 2019-12-22: v2.0.0. See the [release
  notes](https://github.com/firepear/homefarm/blob/master/RELEASE_NOTES)
  and the [Reddit
  post](https://www.reddit.com/r/BOINC/comments/ee9dlp/homefarm_2_released/)
  for more details

# Documentation

* Setting up a farm
    * [Controller setup](https://github.com/firepear/homefarm/blob/master/docs/control_install.md)
    * [Compute node install](https://github.com/firepear/homefarm/blob/master/docs/compute_install.md)
* Managing and maintaining your farm
    * [Everyday farm ops](https://github.com/firepear/homefarm/blob/master/docs/management.md)
    * [Add/reinstall a compute node](https://github.com/firepear/homefarm/blob/master/docs/newnode.md)
    * [Backup/reinstall the control node](https://github.com/firepear/homefarm/blob/master/docs/backup.md)
    * [Using GPUs](https://github.com/firepear/homefarm/blob/master/docs/gpgpu.md)
    * [Fixes and Unbreaks](https://github.com/firepear/homefarm/blob/master/docs/fixes.md)
* Problems and troubleshooting
    * If you've found a bug or have a suggestion, please [create a new
      issue](https://github.com/firepear/homefarm/issues) on Github.
    * Sometimes Arch renames packages and other such things, and this
      will cause the update script to break. If this happens to you,
      check out [our Twitter feed](https://twitter.com/firepear) for
      up-to-date workarounds.
* Other
    * Have homefarm? Want to install Arch on a machine that _isn't_
      part of the farm? Follow the compute node install process, but
      don't run `compute-setup` after the first reboot. You'll have a
      core install with a working network connection, ready for user
      creation and install of whatever packages you need.

