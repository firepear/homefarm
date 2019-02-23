# Connecting to compute nodes

After installation, there are two login accounts on each compute node:
`root`, and `farmer`. The passwords for both accounts are set to
randomized strings, which are not recorded during the install
process. The only means of command-line access is via the control
node.

Login as `alarm` on the control node, and then simply do

`ssh farmer@NODE_NAME`

to connect.
