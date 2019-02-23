# Control node install

These first steps will get Arch linux running on your control node.

1. Image an SD card with [Arch Linux
   ARM](https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3),
   and boot the Pi
1. Login as root (password `root`)
1. Run `'cd /home/alarm && git clone https://github.com/firepear/homefarm.git'`
1. Run `'cd homefarm && ./bin/control-setup'`



## Setup mirrorlists and build localrepo

Compute nodes will install almost all their packages from the control
node's local mirror, but new packages will initially be sourced from
the Arch mirrors. To make this a fast process, an geographically
appropriate mirrorlist is needed.

On a machine with a browser:

1. Go to `https://www.archlinux.org/mirrorlist/`
1. Generate a custom userlist for your location (use defaults unless
   you know you need something specific)
1. Copy the generated URL, for use on the control node

On the control node:

1. Login as user `alarm` if you aren't already
1. Run `'curl '[MIRRORLIST_URL]' -o mirrorlist'`
1. Edit `mirrorlist` to uncomment the hosts you want to use as mirrors
1. Run `'mv mirrorlist /var/cache/homefarm'`

Speaking of the local mirror, it's time to create it. Run the cluster
update script as follows:

`'./bin/update --set-mirror MIRROR_URL'`

...where `MIRROR_URL` is the base URL of whichever Arch linux mirror you
want the control node to use to build the local mirror. It should be
one of the mirrors from the list you just generated in the previous
step. Here's a concrete example:

`'./bin/update --set-mirror http://www.gtlib.gatech.edu/pub/archlinux/'`



## Set up the Ansible inventory

Now it's time to define the machines which will be part if your farm.

1. Login as user `alarm` if you aren't already
1. Run `'cd ~/homefarm'`
1. Edit `farm.cfg`:
     * Change `node00` in the `[controller]` stanza to match the name
       you've given the control node
     * Change the names and IP addresses in the `[compute_nodes]`
       stanza to match the machines you'll be setting up as compute
       nodes
1. Edit `/etc/hosts` and add entries for your compute nodes



## Finishing up

The control node is now ready. You can begin [installing compute
nodes](https://github.com/firepear/homefarm/blob/master/docs/compute_install.md).

Default passwords for both `root` and `alarm` accounts are left in
place by the installer. You may change them if you wish; it will not
affect cluster operations.
