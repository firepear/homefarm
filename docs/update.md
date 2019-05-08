# Keeping the farm up to date

As always, cd to `~/homefarm`

Then just run `'./bin/update'`

This will, as appropriate, update:

* Homefarm itself
* The local Arch mirror
* OS packages and/or Ansible on the control node
* OS packages, and/or Ansible, and/or BOINC on the compute nodes

Since Arch is a rolling-release distro, it is recommended to run
`update` at least once a week.

It's safe to run the update script as often as you'd like. If there's
nothing to do, it will simply do nothing! This makes it very easy to
keep all aspects of your cluster up to date.

If you'd like to see the packages being updated in the local repo, run
`'./bin/update -v'`

# Troubleshooting

## One of my compute nodes failed to update

So far, every time I've had _just one_ compute node fail on update, it
has been a glitch of some sort. I assume a failure in the ansible
control connection, or similar. To see if this is what has happened,
ssh to the node and run the OS update manually. From the control node:

```
$ ssh farmer@<NODENAME>

$ sudo pacman -Syu
$ sudo reboot
```

If the `pacman` command succeeds, you're good to go. If not, please file
an issue on github, and include what happens when you run `pacman`.

## The `update` script failed during localrepo processing

This was probably a network glitch. If you're ok waiting for the repo
packages to update again, just run `update` in another day or two.

If you'd like to force the repo update to happen immediately, run this
from the control node:

`rm /var/cache/homefarm/arch/prevmd5`

and rerun `./bin/update`
