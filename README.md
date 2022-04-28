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
  compute or storage nodes. Further:
  * These machines are being used for no other purpose
  * It is okay to wipe their drives
* You are aware of your local network configuration, and have IPs to
  assign to the nodes.
* All nodes are on a private network -- an SSH key with no passphrase
  will be generated for Ansible's use
* You're familiar with BOINC, projects, workunits, and so on



# News

* 2022-04-28: v3.1.0: ARM support removed
* 2022-04-24: v3.0.3: Fixes for Gnatwren deployment playbook
* 2022-04-06: v3.0.2: Fixes for `farmctl status` deadline reporting
* 2022-02-28: v3.0.1: Fixes for `farmctl query`
* 2021-11-26: v3.0.0: Initial monitoring support; long-running control
  container

See the [Release
notes](https://github.com/firepear/homefarm/blob/master/RELEASE_NOTES)
for all updates.



# Documentation

* Setting up a farm
    * [Controller setup](https://github.com/firepear/homefarm/blob/master/docs/control_install.md)
    * [Node installation](https://github.com/firepear/homefarm/blob/master/docs/compute_install.md)
    * [BOINC
      configuration](https://github.com/firepear/homefarm/blob/master/docs/boinc.md)
      -- for compute nodes
    * [Storage configuration](https://github.com/firepear/homefarm/blob/master/docs/storage.md)
    * [Using
      Gnatwren](https://github.com/firepear/homefarm/blob/master/docs/gnatwren.md)
      -- optional, but recommended
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
      check the _Fixes and Unbreaks_ page above, or file a ticket.
* Other
    * Have homefarm? Want to install Arch on a machine that _isn't_
      part of the farm? Follow the compute node install process, but
      don't run `compute-setup` after the first reboot. You'll have a
      core install with a working network connection, ready for user
      creation and install of whatever packages you need.

