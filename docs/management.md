# Keeping the farm up to date

Bring up the controller if needed, and run `'farmctl os-update'`. This will:

* Update Homefarm itself
* Update the controller's Arch package mirror
* Update packages and/or Ansible on the controller
* Update packages on all compute nodes

Since Arch is a rolling-release distro, it is recommended to do an
update around once per week.

It's safe to run the update as often as you'd like. If there's
nothing to do, it will simply do nothing! This makes it very easy to
keep all aspects of your cluster up to date.

