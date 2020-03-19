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

* 2020-03-18: v2.4.0: Added the `query` subcommand (See "Everyday farm
  ops", below, for more info). Also, Homefarm scripts/utils are now
  pushed to nodes when Homefarm itself updates, ensuring that they
  stay in sync
* 2020-03-18: v2.3.3: Minor bugfix for version reporting
* 2020-02-25: v2.3.2: Overdue deadlines handled correctly in `status`
* 2020-02-04: v2.3.1: Improvements to `status` connection handling
* 2020-01-25: v2.3.0: Renamed `os-update` to `update`. Various
  formatting improvements

See the [Release
notes](https://github.com/firepear/homefarm/blob/master/RELEASE_NOTES))
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

