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

* 2020-05-26: v2.6.0: Added support for injecting packages via the
  initial pkgs list.
* 2020-05-02: v2.5.2: JSON improvements and bugfixes
* 2020-04-24: v2.5.1: Refactoring and bugfixes in `query` and networking
* 2020-04-12: v2.5.0: `status` and `query` can now output JSON
* 2020-03-22: v2.4.3: `query` now returns total elapsed CPU time for matching WUs
* 2020-03-21: v2.4.2: `query` can operate across all projects
* 2020-03-19: v2.4.1: Changed playbook semantics to fix bug cause by
  file move. Scripts now pushed to nodes with every update.

See the [Release
notes](https://github.com/firepear/homefarm/blob/master/RELEASE_NOTES)
for all updates.

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

