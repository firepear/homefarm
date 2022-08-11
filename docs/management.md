# Managing your farm

In Homefarm, all management is done through the `farmctl` tool. To see
what it can do, run `farmctl help`. Its subcommands are
tab-completable, too!

This document assumes that you are in the controller container.


# Compute node management

## Checking BOINC project status

Use `farmctl status`. Run it anytime you'd like to see what the
compute nodes in your farm are doing. If too much output is generated
to fit onscreen, `less` will be invoked.

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

## Getting BOINC project statistics

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

## Managing joblogs

Each BOINC project has a joblog which records statistics about
processed WUs. This file is not managed by the `boinc-client` service
and therefore does not get rotated as the service's logs do. It grows
fairly slowly though, and would take a very long time to fill up any
appreciable fraction of a modern storage device. Homefarm does give
you a tool to manage these files, though.

To check the disk space being used by all joblogs, use `farmctl joblog
size`. Sample output:

```
------------------------------------------------------------------------- node06

196K    /var/lib/boinc/job_log_asteroidsathome.net_boinc.txt
1.4M    /var/lib/boinc/job_log_einstein.phys.uwm.edu.txt
368K    /var/lib/boinc/job_log_www.gpugrid.net.txt
```

If there are any logs you'd like to truncate (or logs from detached
projects that you'd like to remove), use `joblog clean <URL>`, where
`URL` is the project URL as reported in the output of `joblog size`.


## JSON output

Some Homefarm commands can generate JSON as well as human-readable
reports. Currently `query` and `status` can do this.

When JSON is requested, output will not be paged.

If the value of `err` in JSON output is not `null`, then there was an
error getting results for that host and its data should be
disregarded. The value of `err` will be the error message.

**`query`**

To get JSON from `query`, add `-j` to your command line. The output
will be formatted as:

```
[ { "host": HOSTNAME, "proj": PROJNAME, "wutype": WU_TYPE,
    "span": HOURS, "matches": WU_COUNT, "cputime": SECONDS,
    "times": [ MIN, MAX, AVG ],
    "quints": [ [ Q1_TIME, Q1_COUNT, Q1_PERCENT ], ... Q5 ],
    "err": null }, ... ]
```

The fields mostly map onto the arguments for `query`. The rest can be
seen in its output. 

**`status`**

To get JSON from `status`, add `json` to the command line. The
resulting data will be a dict/map of hosts, each of which contains a
dict/map of projects, each of which contains data about the project
and a list of tasks.

```
{ HOSTNAME1: {
    "err": null,
    PROJNAME1: {
      'url': PROJURL, 'state': PROJSTATE, 'username': USER, 'taskcount': TOTALTASKS, 'taskactive': ACTIVETASKS,
      'usercredit': USERCRED, userrac: USERRAC, 'hostcred': HOSTCRED, 'hostrac': HOSTRAC,
      'tasks': {
        TASKNAME: {
          'state': BOINCSTATE, 'active': (true|false), 'cpu_eta': ETA_SECS, 'deadline': DEADLINE_EPOCH,
          'done': DONE_FRAC, 'astate': ACTIVITY_STATE, 'cpu_elapsed': RUNTIME_SECS },
        TASKNAME2: { ... },
        ...
      },  # end tasks
    },    # end PROJNAME1
    PROJNAME2: { ... },
    ...
  },
  HOSTNAME2: { ... },
  ...
}
```

Running `~/homefarm/farmctl status-only` will give a status report on
all hosts, in JSON format, rather than starting a `farmctl`
shell. This allows you to redirect/pipe a system status to the
location/tool of your choice.



# Keeping the farm up to date

Run `farmctl update`. This will:

* Update Homefarm itself
* Update the controller's Arch package mirror
* Update packages on all compute nodes

Since Arch is a rolling-release distro, it is recommended to do an
update around once per week.

It's safe to run the update as often as you'd like. If there's
nothing to do, it will simply do nothing! This makes it very easy to
keep all aspects of your cluster up to date.

Sometimes you _only_ want to update the local package repo, without
updating any nodes. Use `farmctl update --repoup` for this.

## Updating the controller image

One thing that `farmctl update` does not affect is the controller
image itself. Over time the OS packages it contains will become out of
date.

It is safe to rebuild the Docker image that `farmctl` runs inside of
at anytime. Since Homefarm's data is stored as a mounted volume rather
than within the image itself, recreating it does not lose any data,
any configuration you may have done, or wipe the local Arch repo.

Just run `exit` to drop out of the farmctl shell, then run
`~/homefarm/bin/farmctl build-image` -- the same command used to
initially construct the controller image.

It is likely not necessary to do this more than every three months or
so.



# Run a command on farm nodes

If you'd like to execute an ad hoc command across the entire farm, use
`farmctl cmd 'COMMAND'`.

Example:

```
# farmctl cmd 'cat /proc/cpuinfo | grep MHz | head -1'
------------------------------------------------------------------------- node01

cpu MHz         : 1814.622

------------------------------------------------------------------------- node02

cpu MHz         : 1830.450

------------------------------------------------------------------------- node03

cpu MHz         : 1890.431
```

`COMMAND` is expected to be a single argument, so use your bash
quoting skills to handle complex requests.

If you want to run a command against only some nodes, use: `farmctl
cmd 'COMMAND' 'REGEXP'`. The second argument is a regular expression
that determines which nodes the command will be run against. Let's say
I have six nodes, two of which are Raspberry Pis:

`node01 node02 node03 node04 nodepi01 nodepi02`

To run a command only against the Pis, I could use `farmctl cmd
'COMMAND' 'pi'`. To reboot the second and third
x86 node, I could use `farmctl cmd 'sudo reboot' 'node0[23]'`
