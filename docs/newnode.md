# Adding or reinstalling a node

## Bringing up a new node

Here are condensed instructions for adding a compute node after
initial cluster setup:

On the controller:
1. Edit `farm.cfg` and add the new node there
1. Add the node to `/etc/hosts` as well
1. Create the new node's config in the `nodes` dir (or symlink to an
   existing node config, as desired)

On the new node:
1. Do the node installation, as per the [Node
   install](https://github.com/firepear/homefarm/blob/master/docs/compute_install.md)
   document

On the controller:

- Compute node
  1. Run `'farmctl boinc-config'`
  1. Run `'farmctl project-sync'`
- Storage node


## Reinstalling an existing node

Simply reinstall the node as per the [Node
install](https://github.com/firepear/homefarm/blob/master/docs/compute_install.md)
docment.  You don't need to make any changes on the controller,
since it already knows about the machine you're reinstalling.

After reinstall is complete, on the controller, run the appropriate
`farmctl` commands, as described at the end of the new node section of
this document.

The node then will be back in service, with the same configuration it
had before.
