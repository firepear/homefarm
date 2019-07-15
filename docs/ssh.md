# Connecting to compute nodes

After installation, there are two login accounts on each compute node:
`root`, and `farmer`. The `farmer` account is used by Ansible, and may
be used for any tasks not requiring root. `farmer` has full,
passwordless sudo access.

The password for `farmer` is set to a randomized string, which is not
recorded during the install process. The only means of command-line
access is via the control node.

To login as `farmer`, run this command from control node:

`ssh farmer@NODE_NAME`

The root password is either randomized, or set to the value provided
during installation.
