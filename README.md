# homefarm
Tools for deploying and managing a BOINC compute farm using Ansible and Arch Linux.

If you have a pre-v0.13 Homefarm install, please see the [upgrade doc](https://github.com/firepear/homefarm/blob/master/docs/upgrade-to-0.13.0.md).

Homefarm makes a few assumptions:

* A Raspberry Pi 3B/B+, to act as the control node.
* One or more machines capable of running Arch Linux, to act as the
  compute nodes.
* You are aware of your local network configuration, and have IPs to
  assign to the nodes.
* You're familiar with BOINC, projects, workunits, and so on.
* All nodes are on a private network, because an SSH key with no
  passphrase will be generated for Ansible's use and the control
  node's default passwords will be left in place.

# Setting up your farm

## Control node install

1. Image an SD card with [Arch Linux
   ARM](https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3),
   and boot the Pi. Login as root.
1. Run `'cd /home/alarm && git clone https://github.com/firepear/homefarm.git'`
1. Run `'cd homefarm && ./bin/control-setup'`

## Set up the Ansible inventory

1. Login as user `alarm` and run `'cd ~/homefarm'`.
1. Edit `farm.cfg`:
     * Change `node00` in the `[controller]` stanza to match the name
       you've given the control node.
     * Change the names and IP addresses in the `[compute_nodes]`
       stanza to match the machines you'll be setting up as compute
       nodes.
1. Edit `/etc/hosts` and add entries for your compute nodes.

## Compute node install

1. Download the [Arch Linux
   installer](https://alpinelinux.org/downloads/) and boot it.
1. If the node uses wifi, bring it up with the following commands:
    1. `ip addr` to find the wireless interface (it will probably
       begin with `wlp`).
    1. `wpa_passphrase ESSID WPA_PASSWD > /etc/wpa_supplicant/w.conf`
       to generate a wpa_supplicant configuration file. This should
       work unless you have a very interesting WiFi setup (and in that
       case, you likely know what your conf file should look like and
       can manually create it).
    1. `wpa_supplicant -B -i IFACE -c /etc/wpa_supplicant/w.conf` to
       attach to WiFi
    1. `dhcpcd IFACE` to obtain an IP address. This may take a few
       seconds; run `ip addr` to watch for the address attaching to
       the interface.
1. Run `'curl -O CONTROL_NODE_IP/compute-install'` to fetch the
   compute node install script from your control node.
1. Run `'/bin/bash ./compute-setup CONTROL_NODE_IP IFACE [ESSID WPA_PASSWD]'`
    * `IFACE` is the interface you wish to set up during the install
    * `ESSID` is the (optional) wireless network you with to connect to
    * `WPA_PASSWD` is the (optional) WPA passphrase for network `ESSID`
    * `ESSID` and `WPA_PASSWD` are not needed if you followed the
      above procedure and the supplicant configuration file exists.
1. Answer the questions the installer asks. It will handle the rest!

After install, the compute node is ready for Ansible to take over its
configuration management. You can test that everything is working by
running `'ansible -m ping NODE_NAME'` from the control node.


## Build and initialize BOINC on the node

When all compute nodes have been installed, return to the control node
and:

1. Run `'ansible-playbook compute-nodes-boinc.yml'` to build and start
   BOINC on the compute nodes, and to generate sample configs for all
   defined compute nodes.
1. If you want to make BOINC configuration changes, edit the
   `cc_[NODE_NAME].xml` file (in the `nodes` directory) for the node
   you wish to change.
     * This file is the standard BOINC `cc_config.xml` file, and will
       have that name when installed on the compute node.
     * Add whatever [BOINC config
       directives](https://boinc.berkeley.edu/wiki/Client_configuration)
       you would like
     * If you want multiple nodes with identical configurations,
       delete the config files for the duplicate nodes and make
       symlinks to the desired config.
1. Edit the node configs (in the `nodes` directory) to declare
   what BOINC projects you want each node to attach to.
     * Edit the placeholder `PROJ_URL`, `PROJ_EMAIL_ADDR`, and
       `PROJ_PASSWORD` values for each project.
     * Change the project `status` if you'd like.
     * Add/delete stanzas as needed.
     * If you want multiple nodes with identical configurations,
       delete the config files for the duplicate nodes and make
       symlinks to the desired config.
1. Run `'ansible-playbook update-projects.yml'` to attach nodes to
   projects.

Your compute farm should then begin communicating with the servers of your
projects, and start crunching workunits!



# Managing the farm

All commands are to be run on the control node, as user `alarm`, from
`/home/alarm/homefarm`

## Farm status

The program `boinctui` is installed on the control node, and its
configuration is kept in sync with the farm by the `update-projects`
playbook.

Run it anytime you'd like to see what your farm is doing.

It can also be used for ad-hoc management of individual compute nodes,
and the workunits being handled by those nodes.


## Keeping the farm up to date

Run `'./bin/update'`

This script will update the OS packages on all nodes, and check github
to find the current version of homefarm.

If any changes are made, all nodes will be rebooted after updates are complete.

Since Arch is a rolling-release distro, it is recommended to run
`update` at least once a week.


## Adding/removing/modifying BOINC projects

Edit `nodes/[NODE_NAME].yml` for any nodes you wish to modify.

* To define and attach to a new project, create a new stanza in the
  `projects` dict and set the project state to `active`
* To suspend work on a project, set project state to `suspended`
* To resume work on a project, set project state to `active`
* To finish the workunits you have, but not request more, set project state to `nomorework`
* To restart work from a state of `nomorework`, set project state to `active`
* To detach from a project entirely, set project state to
  `detached`.
  * There is no reason to remove detached project stanzas unless you
    wish to clean up the file, and leaving them in place makes it easy
    to re-attach later.

Then run `'ansible-playbook update-projects.yml'` to have the changes
pushed out to the node(s).

To change the user a node is running a project as:

* Set project state to `detached`
* Run the `update-projects` playbook
* Update the user info and set the state to `active`
* Re-run the playbook

## Configuring BOINC

Edit `nodes/cc_[NODE_NAME].xml` for any nodes you wish to modify.

Add and/or update whatever [BOINC config
directives](https://boinc.berkeley.edu/wiki/Client_configuration) you
would like.

Run `'ansible-playbook compute-nodes-boinc.yml'` to push the changes
out to the node(s).

## Bringing up a new node

Here are the condensed instructions for adding a compute node after
initial cluster setup:

On the controller:
1. Edit `farm.cfg` and add the new node there.
1. Add the node to `/etc/hosts`

On the new compute node:
1. Do the node installation

On the controller:
1. Run `'ansible-playbook compute-nodes-boinc.yml'`
1. Edit the new node's config, or symlink to an existing node config
   in the `nodes` dir.
1. Run `'ansible-playbook update-projects.yml'`

For full descriptions of these steps, refer back to the *Setting up
your farm* section.

