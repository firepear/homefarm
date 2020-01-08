# Managing your farm

In Homefarm, all management is done through the `farmctl` tool. To see
what it can do, run `farmctl help`. Its subcommands are
tab-completable, too!

This document assumes that you are in the controller container.



## Checking farm status

Use `farmctl status`. Run it anytime you'd like to see what the
machines in your farm are doing. If too much output is generated to
fit onscreen, `less` will be invoked.

If you don't want paging, invoke it with `farmctl status nopage`

You can also get the status of a single node with `farmctl status <NODENAME>`

Representative output:
```
================================================================================
node06
================================================================================
Einstein@Home     User: someuser      State: Active
Tasks: 13         Active: 1       Credit/RAC: 75115/6339
--------------------------------------------------------------------------------
     Workunit                                     Stat  Prog     ETA      Dline
--------------------------------------------------------------------------------
  1  h1_1072.20_O2C02Cl4In0__O2MDFG2e_G34731_107  Run    0.08%   47m49s    6d18h
--------------------------------------------------------------------------------
World Community Grid      User: someuser      State: Active
Tasks: 50         Active: 16      Credit/RAC: 53914/3231
--------------------------------------------------------------------------------
     Workunit                                     Stat  Prog     ETA      Dline
--------------------------------------------------------------------------------
  1  MIP1_00265053_1409_0                         Run   93.33%   16m27s    9d08h
  2  MCM1_0157754_0687_0                          Run   93.23%   18m47s    6d06h
  3  MCM1_0157776_9328_0                          Run   64.36%    1h27m    6d10h
  4  MIP1_00265646_0966_0                         Run   62.86%   57m14s    9d10h
  5  MCM1_0157729_5344_1                          Run   61.84%    1h33m    6d10h
  6  MIP1_00265670_2587_0                         Run   56.67%    1h06m    9d11h
  7  MIP1_00265670_2033_0                         Run   50.00%    1h17m    9d11h
  8  MIP1_00265708_0787_1                         Run   45.71%    1h23m    9d11h
  9  MIP1_00265741_1507_0                         Run   42.50%    1h28m    9d12h
 10  MIP1_00265687_1765_0                         Run   40.00%    1h32m    9d12h
 11  MIP1_00265723_0205_0                         Run   40.00%    1h32m    9d12h
 12  MCM1_0157769_9757_0                          Run   37.22%    2h34m    6d11h
 13  MIP1_00265745_0662_0                         Run   36.67%    1h37m    9d12h
 14  MIP1_00265723_0299_0                         Run   20.00%    2h03m    9d12h
 15  MCM1_0157776_8715_0                          Run   14.76%    3h29m    6d12h
 16  MCM1_0157729_7533_1                          Run   10.53%    3h39m    6d13h
```

To quickly check on your nodes without starting up an interactive
farmctl session, you can run `/HOMEFARM_PATH/bin/farmctl
status-only`. The output will go to to stdout and you'll be returned
to your command line. If your Homefarm install is not at `~/homefarm`,
you'll need to pass the location as an argument. `status-only` does
not support single-node reporting.



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
# farmctl cmd 'sensors | grep Tdie'
--------------------------------------------------------------
node01
Tdie:         +57.0 C  (high = +70.0 C)

--------------------------------------------------------------
node02
Tdie:         +59.5 C  (high = +70.0 C)

--------------------------------------------------------------
node03
Tdie:         +56.5 C  (high = +70.0 C)
```

`COMMAND` is expected to be a single argument, so use your bash
quoting skills to handle complex requests.



## Managing BOINC

### Adding/removing/modifying BOINC projects

Edit `nodes/<NODE_NAME>.yml` for any nodes you wish to modify.

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

Edit `nodes/cc_<NODE_NAME>.xml` for any nodes you wish to modify. Add
and/or update whatever [BOINC config
directives](https://boinc.berkeley.edu/wiki/Client_configuration) you
would like.

Run `'farmctl project-sync'` to push the changes out to the nodes.


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




