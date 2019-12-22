# Managing your farm

In Homefarm, all management is done through the `farmctl` tool. To see
what it can do, run `farmctl help`. Its subcommands are
tab-completable, too!

This document assumes that you are in the controller container.



## Checking farm status

Use `farmctl status`. Run it anytime you'd like to see what the
machines in your farm are doing. It can generate a lot of output, so
you might want to pipe it to a pager.



## Keeping the farm up to date

Run `'farmctl os-update'`. This will:

* Update Homefarm itself
* Update the controller's Arch package mirror
* Update packages and/or Ansible on the controller
* Update packages on all compute nodes

Since Arch is a rolling-release distro, it is recommended to do an
update around once per week.

It's safe to run the update as often as you'd like. If there's
nothing to do, it will simply do nothing! This makes it very easy to
keep all aspects of your cluster up to date.



## Run a command on all nodes

If you'd like to execute an ad hoc command across the entire farm, use
`farmctl cmd 'COMMAND'`.

Example:

```
$ farmctl cmd 'sensors | grep Tdie'
--------------------------------------------------------------
node01
Tdie:         +57.0 C  (high = +70.0 C)

--------------------------------------------------------------
node02
Tdie:         +59.5 C  (high = +70.0 C)

--------------------------------------------------------------
node03
Tdie:         +56.5 C  (high = +70.0 C)

--------------------------------------------------------------
node04
Tdie:         +53.8 C  (high = +70.0 C)
```

`COMMAND` is expected to be a single argument, so use your bash
quoting skills to handle complex requests.



## Managing BOINC

### Adding/removing/modifying BOINC projects

Edit `nodes/[NODE_NAME].yml` for any nodes you wish to modify.

* To define and attach to a new project, create a new stanza in the
  `projects` dict and set the project state to `active`
* To suspend work on a project, set project state to `suspended`
* To resume work on a project, set project state to `active`
* To finish the workunits you have, but not request more, set project state to `nomorework`
* To restart work from a state of `nomorework`, set project state to `active`
* To detach from a project entirely, set project state to `detached`.
  * There is no reason to remove detached project stanzas unless you
    wish to clean up the file, and leaving them in place makes it easy
    to re-attach later. You can also comment them out.

Run `'farmctl project-sync'` to have the changes pushed out to
the node(s).

To change the user a node is running a project as:

* Set project state to `detached`
* Run  `'farmctl project-sync'`
* Update the user info and set the state to `active`
* Re-run  `'farmctl project-sync'`

### Configuring BOINC itself

Edit `nodes/cc_[NODE_NAME].xml` for any nodes you wish to modify.

Add and/or update whatever [BOINC config
directives](https://boinc.berkeley.edu/wiki/Client_configuration) you
would like.

Run `'farmctl project-sync'` to push the changes
out to the node(s).


## Connecting to compute nodes

After installation, there are two login accounts on each compute node:
`root`, and `farmer`.

The `farmer` account is used by Ansible, and may be used for anything
you'd like. It has full, passwordless `sudo` access. The password for
`farmer` is set to a randomized string, which is not recorded during
the install process. To login as `farmer`, from the controller:

`ssh farmer@NODE_NAME`

The `root` password is either randomized, or set to the value provided
during installation. SSH access is disabled. The intent is to either
not use root at all, or use it only for emergency maintenance with
physical access.




