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
node05
================================================================================
Asteroids@home    User: username  State: Active
Tasks: 0          Active: 0       Credit/RAC: 1176960/2319
--------------------------------------------------------------------------------
Einstein@Home     User: username  State: Active
Tasks: 0          Active: 0       Credit/RAC: 5793205/46106
--------------------------------------------------------------------------------
GPUGRID   User: username      State: Active
Tasks: 2          Active: 1       Credit/RAC: 11550174/240838

     Workunit                                     Stat  Prog    ETA      Dline
     -------------------------------------------  ----  ------  -------  -------
  1  2p0oA02_379_4-TONI_MDADpr4sp-5-10-RND9684_0  Run   80.00%   15m48s    4d22h
--------------------------------------------------------------------------------
Rosetta@home      User: username  State: Active
Tasks: 18         Active: 3       Credit/RAC: 68527/2002

     Workunit                                     Stat  Prog    ETA      Dline
     -------------------------------------------  ----  ------  -------  -------
  1  hgfp_high_lddt_171_fold_SAVE_ALL_OUT_908892  Run   86.90%    1h03m    1d18h
  2  Mini_Protein_binds_IL1R_COVID-19_design6_SA  Run   68.10%    2h39m    1d19h
  3  hgfp_splitdimer_460_fold_SAVE_ALL_OUT_90847  Run   29.72%    5h42m    1d19h
--------------------------------------------------------------------------------
World Community Grid      User: username  State: Active
Tasks: 43         Active: 13      Credit/RAC: 975172/8101

     Workunit                                     Stat  Prog    ETA      Dline
     -------------------------------------------  ----  ------  -------  -------
  1  MIP1_00289342_0437_0                         Run   86.67%   29m21s    9d12h
  2  MIP1_00289403_1006_0                         Run   78.18%   47m37s    9d12h
  3  MCM1_0161950_7544_1                          Run   75.16%   49m23s    6d12h
  4  MCM1_0161846_8578_0                          Run   72.92%    1h28m    6d12h
  5  MCM1_0161939_2531_0                          Run   68.53%    1h03m    6d15h
  6  MCM1_0161945_9716_0                          Run   59.10%   49m26s    6d15h
  7  MIP1_00289342_5634_0                         Run   53.33%    1h45m    9d12h
  8  MIP1_00289276_16981_0                        Run   41.43%    1h14m    9d12h
  9  MIP1_00289276_16992_0                        Run   41.43%    1h14m    9d12h
 10  MIP1_00289276_16902_0                        Run   41.43%    1h14m    9d12h
 11  MIP1_00289276_17002_0                        Run   41.43%    1h14m    9d12h
 12  MCM1_0161954_4788_0                          Run   21.97%    1h34m    6d15h
 13  MCM1_0161859_0528_1                          Run    4.51%    1h55m    6d15h
```

To quickly check on your nodes without starting up an interactive
farmctl session, you can run `/HOMEFARM_PATH/bin/farmctl
status-only`. The output will go to to stdout and you'll be returned
to your command line. If your Homefarm install is not at `~/homefarm`,
you'll need to pass the location as an argument. `status-only` does
not support single-node reporting.

### Getting project statistics

If you'd like to get basic statistics on how your farm is performing
on a certain project (or even workunit type), the `query` subcommand
can be of use. The simplest form of the command is

`farmctl query PROJECT_NAME`

Where `PROJECT_NAME` is a unique fragment of the project's URL. If
there are no matches, you'll see an error message, and the same will
happen if there's more than one match. For instance, if I'm attached
to both World Community Grid and GPUGrid, then `grid` isn't unique. I
should use something like `community` for one and `gpu` for the other.

In any case, in this form, `query` will report the number of WUs
crunched for that project in the past 24 hours; minimum, maximum, and
average runtimes; and counts of WUs bucketed into quintiles by
runtime:

```
# farmctl query community
------------------------------------------------------------------------- node01
WUs for World Community Grid in past 24 hours: 244
Total CPU time used:  19d 09h 54min 45s
        Min runtime: 00h 19min 39s
        Max runtime: 11h 31min 01s
        Avg runtime: 01h 54min 34s
WUs by quintile:
        <= 02h 33min 55s         208     (85.2%)
        <= 04h 48min 11s         35      (14.3%)
        <= 07h 02min 27s         0       (00.0%)
        <= 09h 16min 43s         0       (00.0%)
        <= 11h 31min 01s         1       (00.4%)
```

The behavior of `query` can be modified with the following arguments:

- `-t WU_TYPE` -- Filters by searching only for WUs whose name matches
  `WU_TYPE`
- `-s TIMESPAN` -- Specify a number of hours to include, rather than
  the default 24
- `-c` -- Show only WU count and no other stats

```
# farmctl query community -t MCM -s 96 -c
------------------------------------------------------------------------- node01
WUs matching 'MCM' for World Community Grid in past 96 hours: 563
Total CPU time used:  61d 10h 56min 49s
```

If `PROJECT_NAME` is the special value `ALL` (in all caps), then data
for all of a node's attached projects will be evaluated.

```
# farmctl query ALL -c
------------------------------------------------------------------------- node01
WUs for ALL in past 24 hours: 260
Total CPU time used:  23d 18h 02min 55s
```

### JSON output

Some Homefarm commands can generate JSON as well as human-readable
reports. Currently `query` and `status` can do this.

To get JSON from `query`, add `-j` to your command line. The output
will be formatted as:

```
[ { "host": HOSTNAME, "proj": PROJNAME, "wutype": WU_TYPE,
    "span": HOURS, "matches": WU_COUNT, "cputime": SECONDS,
    "err": null }, ... ]
```

The fields mostly map onto the arguments for `query`. If `err` is not
`null`, then there was an error getting results for that host, and its
data should be disregarded.

To get JSON from `status`, add `json` to the command line. The
resulting data will be a dict/map of hosts, each of which contains a
dict/map of projects, each of which contains data about the project
and a list of tasks.

```
{ HOSTNAME1: {
    PROJNAME: {
      'url': PROJURL, 'state': PROJSTATE, 'username': USER, 'taskcount': TOTALTASKS, 'taskactive': ACTIVETASKS,
      'usercredit': USERCRED, userrac: USERRAC, 'hostcred': HOSTCRED, 'hostrac': HOSTRAC,
      'tasks': {
        TASKNAME: {
          'state': BOINCSTATE, 'active': (true|false), 'cpu_eta': ETA_SECS, 'deadline': DEADLINE_EPOCH,
          'done': DONE_FRAC, 'astate': ACTIVITY_STATE, 'cpu_elapsed': RUNTIME_SECS },
        TASKNAME2: { ... },
        ...
      },
    },
    PROJNAME2: { ... },
    ...
  },
  HOSTNAME2: { ... },
  ...
}
```



## Keeping the farm up to date

Run `'farmctl update'`. This will:

* Update Homefarm itself
* Update the controller's Arch package mirror
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




