# homefarm
Configuration and tools for deploying and managing a BOINC compute farm

Homefarm makes a few assumptions:

* Ansible is used for system configuration and orchestration
* The control machine is a Raspberry Pi (running Raspbian)
* The compute nodes are running Alpine Linux

## Control machine setup

1. Image an SD card with Raspbian Lite, boot the Pi, and do any
   initial network/locale/etc configuration that you wish. Reboot if
   necessary.
1. Login as the default user and run `sudo apt-get --yes install git`
1. `git clone https://github.com/firepear/homefarm.git`
1. `cd homefarm`
1. `sudo ./control-setup`
1. Now edit the file `farm.cfg`, which is the machine Ansible
   inventory. Change `node00` in the `[control]` stanza to match the
   name you've given the controller (AKA your Raspberry Pi). Then add
   the names of all the machines you'll be setting up as compute nodes
   to the `[compute]` stanza.
1. Make sure the names and IP addresses of these machines are in your
   controller's `/etc/hosts` file.
