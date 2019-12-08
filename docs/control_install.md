# Controller installation

First, create the controller image

1. Install docker, if you haven't already :)
1. In the directory of your choosing, run `'git clone https://github.com/firepear/homefarm.git'`
    * This git clone will also hold your cluster configuration and act
      as the non-volatile storage for the container you're about to
      create, so put it somewhere reasonably stable.
    * For the purposes of this document, we will assume it is at `~/homefarm`
1. `'cd ~/homefarm'`
1. Build the controler: `'cd docker/control/ && docker build --tag control . && cd ../..'`
    * This will automatically pull the Arch Linux base container for
      you, if needed. This is also the only docker incantation you'll
      need; everything else happens through scripts.

## Bring up the controller

In the previous version of Homefarm, the controller was a separate
machine -- a Raspberry Pi -- and it was dedicated to doing nothing but
managing your farm. Now the controller is a Docker instance, and we
can pop it in and out of existance whenever we need it.

To bring it up, go into your homefarm directory and run:

`./bin/farmctl up ~/homefarm`

And you should see something like the following:

```
Welcome to homefarm
    Local IP is 172.17.0.2
    Installer httpd is listening on DOCKERHOST:9099
    Run 'farmctl' to see options, or refer to the docs
[root@77c3fe3f72ba homefarm]# 
```

From this point, you can issue `farmctl` commands to manage your
compute farm. First there's a little bit of setup to do.

## Initialize the controller environment and local repo

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
