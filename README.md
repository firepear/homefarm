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
  compute or storage nodes
* You are aware of your local network configuration, and have IPs to
  assign to the nodes.
* All nodes are on a private network -- an SSH key with no passphrase
  will be generated for Ansible's use
* You're familiar with BOINC, projects, workunits, and so on

See the [Release
notes](https://github.com/firepear/homefarm/blob/master/RELEASE_NOTES)
for all changes and full history.



# Documentation

* Setting up a farm
    * [Controller setup](https://github.com/firepear/homefarm/blob/master/docs/control_install.md)
    * [Node installation](https://github.com/firepear/homefarm/blob/master/docs/compute_install.md)
* Configuring your farm
    * [BOINC configuration](https://github.com/firepear/homefarm/blob/master/docs/boinc.md)
      -- for compute nodes
    * [Storage configuration](https://github.com/firepear/homefarm/blob/master/docs/storage.md)
    * [Using
      Gnatwren](https://github.com/firepear/homefarm/blob/master/docs/gnatwren.md)
      -- optional, but recommended
* Managing and maintaining your farm
    * [Everyday farm ops](https://github.com/firepear/homefarm/blob/master/docs/management.md)
    * [Add or reinstall a node](https://github.com/firepear/homefarm/blob/master/docs/newnode.md)
    * [Backup or restore the controller](https://github.com/firepear/homefarm/blob/master/docs/backup.md)
    * [Using GPUs](https://github.com/firepear/homefarm/blob/master/docs/gpgpu.md)
    * [Fixes and Unbreaks](https://github.com/firepear/homefarm/blob/master/docs/fixes.md)
* Problems and troubleshooting
    * If you've found a bug or have a suggestion, please [create a new
      issue](https://github.com/firepear/homefarm/issues) on Github.
    * Sometimes Arch renames packages and other such things, and this
      will cause the update script to break. If this happens to you,
      check the _Fixes and Unbreaks_ page above, or file a ticket.
