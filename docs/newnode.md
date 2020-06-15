# Adding a new compute node, or reinstalling an existing one

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


## Reinstalling an existing node

Simply reinstall the node as per the [Compute node
install](https://github.com/firepear/homefarm/blob/master/docs/compute_install.md)
docment.  You don't need to make any changes on the controller,
since it already knows about the machine you're reinstalling.

After `node-setup` is complete, on the controller:

1. Run `'farmctl node-init'`
1. Run `'farmctl project-sync'`

The node then will be back in service, with the same configuration it
had before.
