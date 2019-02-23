# Keeping the farm up to date

As always, cd to `~/homefarm`.

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
