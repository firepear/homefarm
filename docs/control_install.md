# Control node install

1. Image an SD card with [Arch Linux
   ARM](https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3),
   and boot the Pi
1. Login as root (password `root`)
1. Run `'cd /home/alarm && git clone https://github.com/firepear/homefarm.git'`
1. Run `'cd homefarm && ./bin/control-setup'`

## Set up the Ansible inventory

1. Login as user `alarm`
1. Run `'cd ~/homefarm'`
1. Edit `farm.cfg`:
     * Change `node00` in the `[controller]` stanza to match the name
       you've given the control node
     * Change the names and IP addresses in the `[compute_nodes]`
       stanza to match the machines you'll be setting up as compute
       nodes
1. Edit `/etc/hosts` and add entries for your compute nodes

The control node is now ready.

Default passwords for both `root` and `alarm` accounts are left in
place by the installer. You may change them if you wish; it will not
affect cluster operations.
