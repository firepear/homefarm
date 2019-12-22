# homefarm

WARNING: homefarm is currently in a broken state as I work out a major upgrade. Thank you for your understanding.

Tools for deploying and managing a BOINC compute farm using Ansible
and Arch Linux.

Homefarm makes it easier -- and _faster_ -- to install, reinstall,
configure, and update all your BOINC crunchboxes. It also makes you a
better netizen: all your compute nodes will install and update from a
local repository that lives on the control node.

Homefarm makes a few assumptions:

* One machine capable of running Docker, to host the control container
* One or more x86_64 machines capable of running Arch Linux, to act as
  the compute nodes.
  * These machines will be used for no other purpose, and it is okay
    to wipe their drives -- Homefarm does not do custom partitioning.
* You are aware of your local network configuration, and have IPs to
  assign to the nodes.
* All nodes are on a private network -- an SSH key with no passphrase
  will be generated for Ansible's use.
* You're familiar with BOINC, projects, workunits, and so on.

# Documentation

* Setting up a farm
    * [Controller setup](https://github.com/firepear/homefarm/blob/master/docs/control_install.md)
    * [Compute node install](https://github.com/firepear/homefarm/blob/master/docs/compute_install.md)
* Managing and maintaining your farm
    * [Everyday farm ops](https://github.com/firepear/homefarm/blob/master/docs/ssh.md)
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
    * Older known update problems will be documented here: [update
      issue
      archive](https://github.com/firepear/homefarm/blob/master/docs/known_issues.md)
* Other
    * Have homefarm? Want to install Arch on a machine that _isn't_
      part of the farm? Follow the compute node install process, but
      don't run `compute-setup` after the first reboot. You'll have a
      core install with a working network connection, ready for user
      creation and install of whatever packages you need.

