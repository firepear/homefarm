# Updating Homefarm to v0.13

Due to the transition from Alpine Linux to Arch Linux, there is no
actual upgrade path. A complete reinstall of all nodes will be
needed. That said, installs are quick, and no data or work need be
lost.

## Back up existing node data

The files you need to save are `~/homefarm/farm.cfg` and the directory
`~/homefarm/nodes`, on the control node. Back them up anywhere, using
any mechanism you desire. They're just text files.

## Halt work

Using either `boinctui` or the per-node configuration files, set the
status of your compute nodes to `nomorework`. Let them exhaust their
queues. When the compute nodes are idle, you're ready for the
reinstalls.

## Reinstall control node

Follow the procedure from the main README, but don't create a new
cluster config from scratch. Just get the node installed and set up.

Once setup is done, copy the backed-up `farm.cfg` and `nodes`
directory into the `homefarm` directory. Your cluster configuration
will be ready to go.

# Reinstall compute nodes

No changes here. Reinstall each node, as per the main README, and it
will end up with its original configuration and projects.
