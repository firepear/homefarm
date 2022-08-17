## 3.6.3 -- 2022-08-17

- Running an update now only reboots nodes which are alive
- `cmd` subcommand now takes a regexp rather than a glob as its
  optional 2nd argument (node specification)
- `app_config.xml` handling should now be more reliable

## 3.6.2 -- 2022-08-11

- `pstracker` now reports time since update in fractions of hours; the
  `query` subcommand now accepts fractional hours as a timespan
  argument


## 3.6.1 -- 2022-08-08

- Fixed storage node detection for ceph subcommands
- Fixed `app_config.xml` deploy for projects with complex URLs


## 3.6.0 -- 2022-08-01

- New convenience subcommand `cephshell`, which runs a management
  shell on the first available storage node
- Improved `cephstat` to also check all storage nodes


## 3.5.0 -- 2022-07-15

- New convenience subcommand `cephstat`, which runs `ceph -s` on the
  first storage node
- Update now generates its node list from `farm.cfg` instead of the
  BOINC node config dir


## 3.4.0 -- 2022-06-18

- Initial storage node tooling in place
- `cmd` is now aware of storage nodes
- `node-install` no longer requires the controller IP passed in
- Fixes to `backup`
- The stash directory for gwagent is now /var/lib
- Fixes to make running F@H easier


## 3.3.1 -- 2022-06-06

- Go is back in the farmcontrol image. Too fiddly the other way
  around.
- lm_sensors is back, but not configured, because mesa needs it
- Various fixes and tweaks to playbooks and package lists
- Removed localpkgs functionality (actually a while back)


## 3.3.0 -- 2022-05-06

- Added repo update-only mode to `farmctl update`. This is handy
  for install purposes
- Moved boinc-client enable from installer to boinc-config
  playbook
- Removed lm_sensors from installer packages. Further package list
  fixes


## 3.2.2 -- 2022-05-04

- Main git branch renamed from `master` to `main`. `update` changed to
  match this


## 3.2.1 -- 2022-05-04

- Fixed some missing dependencies from the BOINC packages list
- Doing a system update now updates pacman.conf
- Misc small fixes


## 3.2.0 -- 2022-05-02

- Added a farmctl subcommand, 'joblog' which allows for checking
  joblog sizes and cleaning them up
- Added per-node, per-project configuration support
- A cc.xml file is no longer required for each node
- Removed obviated copy of gwagent-config.json
- Misc tweaks, improvements, and fixes
- Go is no longer part of the farmcontrol docker image. It is now
  installed alongside gnatwren


## 3.1.0 -- 2022-04-28

- Removed ARM support
- Began work to support storage as well as compute clients
- Removed unmaintained `testnode` dockerfile
- As this is a breaking change, it should be v4. But I'm almost
  entirely sure no one else uses this, so the impact is nil and I'm
  calling it v3.1


## 3.0.3 -- 2022-04-24

- Fixed gnatwren playbook not restarting gwagent when a new binary
  deployed.


## 3.0.2 -- 2022-04-06

- Fixed `farmctl status` broken deadline reporting when a WU was
  overdue


## 3.0.1 -- 2022-02-28

- The `query` util was not reporting errors when they existed
  and JSON output was not requested. Fixed.


## 3.0.0 -- 2021-11-26

- A monitoring and metrics platform, Gnatwren, is now
  available. See the Using Gnatwren doc for more information
- Homefarm's control container is now long-running rather than
  transient, with `farmctl up` now only being needed initially, or
  after a `farmctl down` or image rebuild
- `farmctl attach` is the new `farmctl up`
- `farmctl query` now handles connection failures gracefully
  rather than dying
- Improvements to `farmctl build-image`
- Added 'HISTCONTROL=ignoreboth' to bashrc
- Misc fixes and improvements


## 2.8.2 -- 2021-01-11

- Added Go (the programming language) to the controller dockerfile
  in support of Gnatwren
- Fixes to control image builds


## 2.8.1 -- 2020-12-26

- The update process now happens once per architecture, rather than
  having per-arch and interleaved sections. This makes the overall
  process take longer, but keeps updated arches from waiting for
  others to finish
- Removing node-setup broke the configuration of lm_sensors on
  install. That now happens at boot in a systemd unit
- Fixed errors in running the `boinc-config` subcommand on
  multiple architectures
- tmux, dmidecode, and dependencies added to x86_64 packages list


## 2.8.0 -- 2020-10-25

- Multi-arch support is enabled. Homefarm can now deploy and
  manage heterogenous farms (currently: x86_64, armv7h)
- 'localpkg' files allow inclusion of user-selected packages into
  the local repo mirrors
- node-setup is no longer needed; installation is no longer a
  multi-reboot process
- The 'cmd' subcommand now accepts a second argument, which is a node
  name glob, allowing commands against a specified subset of the farm
- Various fixes and improvements


## 2.7.1 -- 2020-07-08

- Subcommand rename: `node-init` -> `boinc-config`. This better
  reflects its current status as something which is not only used to
  initialize nodes
- BOINC client configuration file now correctly deployed to
  compute nodes
- cc filename changed on controller from cc_NODE.xml to
  NODE-cc.xml to sort per-node configs together
- Enabled logging of `file_xfer` events, which upstream BOINC
  seems to have compiled out in recent months


## 2.7.0 -- 2020-06-19

- Homefarm now has a configuration file, making code simpler and
  more maintainable
- New subcommand: `build-image` which automates (re)building the
  control Docker image
- Many fixes for initial container setup, and rewrite of
  controller doc as a result of this
- Initial work done to support Homefarm on non-x86 architectures
- Automated downloads now fail if xfer speeds are < 1kBps for more
  than 10 seconds, rather than a forced failure after 60 seconds
- Much infra work and restructuring. Many bugfixes and doc tweaks



## 2.6.0 -- 2020-05-26

- Added `smartmontools` to initial packages list
- Initial package list and first node package list are now merged when
  `farmctl update` is run, so that the localrepo catches updates to
  the init package list
- Packages which are in initial package list but not in the first
  node's package list are now deployed to nodes on update
- `pstracker` util now uses a sqlite DB to track stats


## 2.5.2 -- 2020-05-02

- Fixed two error cases in `status` that did not return JSON
- JSON output from `status` now always includes `err`
- `status` now uses f-strings


## 2.5.1 -- 2020-04-24

- `query` refactored to avoid data duplication arising from hasty
  JSON implementation
- JSON returned by `query` is now invariant, always including
  `times` and `quints` data
- Much improved documentation in `query` code
- Simplification of socket reading code


## 2.5.0 -- 2020-04-12

- `query` now returns JSON when invoked with `-j`
- `status` now returns JSON when invoked with `json`
- `node-init` now only restarts BOINC if the unit file has changed
- Python scripts now use a shared common module to eliminate code
  duplication
- `cmd` and `query` now use the same format for hostname headers,
  and `cmd` is using the common shell func for this


## 2.4.3 -- 2020-03-22

- `query` now returns total elapsed CPU time for matching WUs


## 2.4.2 -- 2020-03-21

- Allow "ALL" as project name for `query`, to operate on all
  extant job logs


## 2.4.1 -- 2020-03-19

- Use 'command' instead of 'script' in project sync playbook
- Run nodes-boinc-setup playbook with every update


# 2.4.0 -- 2020-03-19

- Added the `query` subcommand
- `node-init` is now called when Homefarm itself is updated. This
  ensures that utils are pushed to the nodes if needed


# 2.3.3 -- 2020-03-18

- Fixed minor bug with version setting


# 2.3.2 -- 2020-02-25

- Overdue deadlines are now handled correctly in `status`


# 2.3.1 -- 2020-02-04

- Better connection checking/error reporting in the `status`
  subcommand.
- Updated fixes doc with handling of probably cause of `status`
  breakage after `update`


# 2.3.0 -- 2020-01-25

- 'os-update' subcommand has been renamed to 'update'
- Improvements to 'status' formatting
- Improved error reporting on 'project-sync'


## 2.2.0 -- 2020-01-08

- OS package updates no longer happen on the controller. This is in
  preparation for a tool which will assist in (re)builds of controller
  containers to make them easy to update
- 'status' can now be run against a specific node


## 2.1.0 -- 2020-01-05

- 'status-only' subcommand allows getting compute node status
  without bringing up an interactive controller session
- 'status' now takes an optional argument, 'nopage' which inhibits
  autopaging
- Shell history now retained between sessions
- Version number now reported on startup


## 2.0.1 -- 2020-01-04

- Fixes for Arch adding zstd-compressed packages
- 'os-update' now warns about failure to download individual packages,
   rather than erroring out of downloading any further packages
- 'status' now reports that it can't connect to a node, rather
  than erroring out when any node is unreachable


## 2.0.0 -- 2019-12-22

- As indicated by the major version number change, this release has
  incompatibilities with previous releases. Specifically, Raspberry Pi
  computers are no longer (directly) supported as control nodes. The
  controller is now a Docker container, run on any machine. A new
  controller instance will be required, and all compute nodes should
  be drained of WUs and reinstalled.
- There is a new, unified, cluster management tool, farmctl, with
  tab-completion support for its sub-commands
- boinctui is no longer available on the controller. It is
  replaced by 'farmctl status'
- BOINC is no longer built on compute nodes; stock Arch packages
  are now used
- Many simplifications and refactorings across the Ansible
  playbooks and project organization
- root passwords on compute nodes are now set correctly on install
- Long-standing 'sed' bug in compute node setup is fixed
- Many smaller changes and fixes


## 1.2.0 -- 2019-07-15

- Root password can now be set on compute nodes at install time
- Boot parameters can now be set on compute nodes at install time
- BOINC work directory now world-readable
- New utility scripts


## 1.1.4 -- 2019-05-12

- More robust package download handling in update script
- Faster repo DB building


## 1.1.3 -- 2019-04-11

- BOINC is no longer restarted after system update on compute
  nodes, since a restart happens a few seconds afterward.


## 1.1.2 -- 2019-03-22

- A reference to pip-installed Ansible was missed in v1.1.0, in
  the control node update process. This has been removed.
- pip removed from initial packages list for localrepo
- Fix for bad TZ symlinks in compute-install


## 1.1.1 -- 2019-03-16

- Update initial packages list


## 1.1.0 -- 2019-03-09

- Use distro Ansible package
- Halt BOINC while OS upgrades are occurring


## 1.0.0 -- 2019-02-23

- Improvements to backup utility
- Documentation improvements


## 0.16.0 -- 2019-02-21

- Homefarm now maintains a local repository of packages for compute
  nodes, so updates are faster and update bandwidth is O(2) instead of
  O(n+1)
- Update efficiency and output formatting improvements
- Added farm configuration archive/restore utility
- NVMe devices now supported as install targets
- Ansible SSH timeout upped to 30s


## 0.15.0 -- 2019-01-17

- BOINC logfiles are now rotated
- README has been split out into a collection of documents
- Update and install script improvements


## 0.14.0 -- 2019-01-13

- Installer fixes and QoL improvements
- lm_sensors now auto-configured on install


## 0.13.2 -- 2019-01-08

- Update script improvements


## 0.13.1 -- 2019-01-06

- Script cleanups
- Doc updates


## 0.13.0 -- 2019-01-05

- Project migrated to Arch Linux
- GPGPU now possible under Homefarm
- Temperature sensors now work as expected on Ryzen CPUs
- Multiple compute-setup fixes
- Improved update script


## 0.12.1 -- 2018-11-01

- Compute nodes now have a cc_config.xml file deployed, enabling
  per-node BOINC configuration
- Improved messages in scripts
- Added confirmation to `update-farm` script


## 0.11.0 -- 2018-10-13

- Automated homefarm and system updates via the update-farm script
- BOINC version updated to 7.14.2
- Playbooks updated to Ansible 2.7 format where needed


## 0.10.0 -- 2018-10-11

- Init script reliably handles stop/restart now.
- Scripts not meant to be run by users say so when run with no
  arguments, or with '-h/'--help'.
- Fixed bug in .boinctui file generation due to faulty node name
  handling


# 0.9.1 -- 2018-09-18

- Initial featureset complete. Public announcement.
