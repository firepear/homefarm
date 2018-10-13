# homefarm
Tools for deploying and managing a BOINC compute farm using Ansible, Raspbian, and Alpine Linux.

Homefarm makes a few assumptions:

* You have a Raspberry Pi, to act as the control node.
* You have one or more machines capable of running Alpine Linux, to
  act as the compute nodes.
* You are comfortable doing basic Linux installs. Homefarm takes
  care of just about everything beyond the core install and network
  configuration, but getting to that point is on you.
* You're familiar with BOINC, projects, workunits, and so on.
* You are on a private network, because an SSH key with no passphrase
  will be autogenerated for Ansible's use.

# Setting up your farm

## Control node install

1. Image an SD card with [Raspbian
   Lite](https://www.raspberrypi.org/downloads/raspbian/), boot the
   Pi, and do any initial network/locale/etc configuration that you
   wish. (Recommended: enable the ssh daemon via `raspi-config`.)
   Reboot if necessary.
1. Login as the default user and run `'sudo apt-get --yes install git'`
1. Run `'git clone https://github.com/firepear/homefarm.git'`
1. Run `'cd homefarm && sudo ./bin/control-setup'`. The Pi will
   reboot after this script completes.

## Set up the Ansible inventory

1. Run `'cd ~/homefarm'`.
1. Edit `farm.cfg`:
     * Change `node00` in the `[controller]` stanza to match the name
       you've given the controller (AKA your Raspberry Pi).
     * Change the names and IP addresses in the `[compute_nodes]`
       stanza to match the machines you'll be setting up as compute
       nodes.
1. Edit `/etc/hosts` and add entries for your compute nodes.

## Compute node install

Before installing a new compute node, login to the control node and
run `'cd ~/homefarm && ./bin/serve-config'`. This will start a Python
webserver to make available the `compute-setup` script and data needed
by that script. When done with installs, terminate the server with
`Ctrl-C`.

For the compute node:

1. Download [Alpine Linux
   Standard](https://alpinelinux.org/downloads/) and install it.
1. Login after reboot
    * If you're on a wired connection, skip to step #3.
    * If you installed via WiFi, you'll likely be surprised to learn
      that it was not permanently enabled by the installer. Your
      configuration is still there though. Run
      `'/etc/init.d/wpa_supplicant start'` to bring up the networking
      for this boot.
    * Then run `'rc-update add wpa_supplicant boot'` to enable WiFi
      for all future boots.
1. Run `'wget [CONTROL_NODE_IP]:8000/compute-setup'` to fetch the
   compute node setup script from your control node.
1. Run `'sh ./compute-setup [CONTROL_NODE_IP]'`. This first run will
   update to Alpine's rolling release distro, and then reboot to
   ensure all libraries are up to date.
1. Log back after reboot and re-run `'sh ./compute-setup
   [CONTROL_NODE_IP]'` to complete bootstrapping.
1. Reboot a final time..

At this point the compute node is ready for Ansible to take over its
configuration management. You can test that everything is working by
running `'ansible -m ping [NODE_NAME]'` from the control node.


## Build and initialize BOINC on the farm

When all compute nodes have been installed, return to the control node
and:

1. Run `'ansible-playbook compute-nodes.yml'` to build and start
   BOINC on the compute nodes, and to generate sample
   configs for all defined compute nodes.
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

All commands are assumed to be run from `~/homefarm`.

## Farm status

The program `boinctui` is installed on the control node, and its
configuration is kept in sync with the farm by the `update-projects`
playbook.

Run it anytime you'd like to see what your farm is doing.

It can also be used for ad-hoc management of individual compute nodes,
and the workunits being handled by those nodes.


## Keeping the farm up to date

Run `'./bin/update-farm'`

This script will check github to find the current version of
homefarm. If you are up-to-date, no action will be taken.

If there is a new version, then:

* The control node's clone of homefarm will be updated
* The control node's OS and ansible packages will be updated
* The compute nodes will have their OS and ansible packages updated
* BOINC will be rebuilt on the compute nodes, if needed
* The compute nodes will restart
* The control node will restart


## Adding/removing/modifying BOINC projects

Edit `nodes/NODE.yml` for any nodes you wish to modify.

* To define and attach to a new project, create a new stanza in the
  `projects` dict and set the project state to `active`.
* To suspend work on a project, set project state to `suspended`.
* To resume work on a project, set project state to `active`.
* To finish the workunits you have, but not request more, set project state to `nomorework`.
* To restart work from a state of `nomorework`, set project state to `active`.
* To detach from a project entirely, set project state to
  `detached`. There is no reason to remove detached project stanzas
  unless you wish to clean up the file, and leaving them in place
  makes it easy to re-attach later.

Then run `'ansible-playbook update-projects.yml'` to have the changes
pushed out to the node(s).


## Bringing up a new node

Here are the condensed instructions for adding a compute node after
initial cluster setup:

On the controller:
1. Edit `farm.cfg` and add the new node there.
1. Add the node to `/etc/hosts`

On the new compute node:
1. Do the node installation

On the controller:
1. Run `'ansible-playbook compute-nodes.yml'`
1. Edit the new node's config, or symlink to an existing node config
   in the `nodes` dir.
1. Run `'ansible-playbook update-projects.yml'`

For full descriptions of these steps, refer back to the *Setting up
your farm* section.

