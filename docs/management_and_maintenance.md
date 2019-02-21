# Managing the farm

Unless specified otherwise, all commands in this document should be
run on the control node, as user `alarm`, from `/home/alarm/homefarm`



## Keeping the farm up to date

Just run `'./bin/update'`

This will, as appropriate, update

* Homefarm itself
* The local Arch mirror
* OS packages and Ansible on the control node
* OS packages, Ansible, and/or BOINC on the compute nodes

Since Arch is a rolling-release distro, it is recommended to run
`update` at least once a week. It's safe to run the update script as
often as you'd like. This makes it very easy to keep all aspects of
your cluster up to date.



## Farm status

The program `boinctui` is installed on the control node, and its
configuration is kept in sync with the farm by the `update-projects`
playbook.

Run it anytime you'd like to see what your farm is doing.

It can also be used for ad-hoc management of individual compute nodes,
and the workunits being handled by those nodes.



## SSH to a compute node

After installation, there are two login accounts on each compute node:
`root`, and `farmer`. The passwords for both accounts are set to
randomized strings, which are not recorded during the install
process. The only means of command-line access is via the control
node.

Login as `alarm` on the control node, and then simply do

`ssh farmer@NODE_NAME`

to connect.



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

Here are condensed instructions for adding a compute node after
initial cluster setup:

On the controller:
1. Edit `farm.cfg` and add the new node there
1. Add the node to `/etc/hosts` as well

On the new compute node:
1. Do the node installation, as per the [Compute node
   install](https://github.com/firepear/homefarm/blob/master/docs/compute_install.md)
   docment

On the controller:
1. Run `'ansible-playbook compute-nodes-boinc.yml'`
1. Edit the new node's config in the `nodes` dir (or symlink to an
   existing node config, as desired)
1. Run `'ansible-playbook update-projects.yml'`



## Enabling GPGPU projects

Homefarm itself doesn't know anything about GPGPU computing, or your
video card. But it also doesn't care -- so just manually install a few
packages to enable OpenCL/CUDA support, and you'll be good to go.

On each machine you wish to be GPGPU-enabled, run:

`sudo pacman -S nvidia opencl-nvidia ocl-icd`

if you have an Nvidia card, or:

`sudo pacman -S opencl-mesa ocl-icd`

for AMD GPUs.

After a reboot, BOINC should see the GPU as usable. Once it does, just
define the project like any other in
`/home/alarm/homefarm/nodes/[NODE_NAME].yml` on the controller, then
run the `update-projects` playbook.

The update script will keep the GPGPU packages up to date along with
everything else.
