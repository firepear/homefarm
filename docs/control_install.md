# Controller installation

Welcome to Homefarm!

The first step toward getting your cluster running is to create a
'controller' container. This container is where cluster administration
will be performed.

This is probably the most involved part of setting up Homefarm,
because the controller handles so many things. It's straightforward
though, and is broken up into four groups of tasks: Building the
controller image, Bringing up the controller, Controller
initialization, and Ansible setup.



## Building the controller image

There's a little bit of prep work to do before we build the container:

1. Install docker, if you haven't already :)
1. In the directory of your choosing, run `'git clone https://github.com/firepear/homefarm.git'`
    * This git clone will also hold your cluster configuration and act
      as the non-volatile storage for the container you're about to
      create, so put it somewhere reasonably stable.
1. Create a config file which simply holds the location of the clone
   you just created
   * `'echo ~/path/to/clone > ~/.homefarmdir'`
   * For the purposes of this document, we will assume it is at `~/homefarm`

Now it's time to build the container image. Run:

`'~/homefarm/bin/farmctl build-image'`



## Bringing up the controller

Starting the controller container is easy. Just run:

`'~/homefarm/bin/farmctl up'`

You should see something like the following:

```
Welcome to homefarm
    Controller IP is 172.17.0.2
    Installer httpd is listening on DOCKERHOST:9099
    Run 'farmctl' to see options, or refer to the docs
[root@77c3fe3f72ba homefarm]#
```



## Controller initialization

Now we need to set up some things on the controller. This is mostly
automatic and/or scripted, but there is one manual step.  We need to
an Arch Linux repo mirrorlist. Arch has a tool that will do this for
you, so on a machine with a browser:

1. Go to [https://www.archlinux.org/mirrors/status/#successful](https://www.archlinux.org/mirrors/status/#successful)
1. Find a mirror that is geographically close to you and has low delay
1. Copy the URL of your chosen mirror

Mn the controller container, edit `./srv/homefarm/mirrorlist-x86_64`
(`vi` and `mg` are available) and add a line:

`Server = MIRROR_URL`

then save and exit


Run `'farmctl init'` to complete initialization of the controller
environment. This is mostly automatic, but it will ask you for:

* The machine architectures you want to mirror packages for. The
  default is `x86_64`. If you only have Raspberry Pis, enter
  `armv7h`. If you have both, enter `x86_64 armv7h`
* The IP address of the host which is running the container



## Ansible setup

The last piece of controller setup is to define the machines which
will be part if your farm.

1. Edit `farm.cfg` and change the names and IP addresses in the
   `[compute_nodes]` stanza to match the machines you'll be setting up
   as compute nodes
2. Exit from the controller container, then bring it back up:
   * `'exit'`
   * `'~/homefarm/bin/farmctl up'`

The control node is now ready. You can begin [installing compute
nodes](https://github.com/firepear/homefarm/blob/master/docs/compute_install.md).
