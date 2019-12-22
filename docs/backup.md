# Backups and restores

Under Homefarm, compute nodes are fungible. We don't care about them;
we only care about their workunits. The controller is different, since
it stores the unique configuration of our farm.  The `backup`
subcommand helps keep this safe.

## Backup the farm

`'farmctl backup'`

This will create a tarball containing every piece of local
configuration for your farm. Move this tarball somewhere safe.

## Recovering a controller

If, for whatever reason, your controller gets messed up, don't
worry. You'll be fine so long as you have a backup tarball.

Don't worry about the compute nodes either. They don't care if the
controller is alive or not; they'll keep on working as-is until you
get a controller rebuilt.

We'll do this cookbook style, to get you back up and running
quickly. As usual, we'll assume that the Homefarm git clone is in your
homedir; if yours isn't, make the appropriate changes.

1. Tear everything down to assure a clean slate
   * `'rm -rf ~/homedir'` (may need `sudo`)
   * `'docker image rm control'`
1. Clone Homefarm again: `'git clone https://github.com/firepear/homefarm.git'`
1. cd into the clone `'cd homefarm'`
1. Copy your backup into the clone: `'cp /PATH/TO/homefarm.backup.tar.gz .'`
1. Ensure your base image is up to date: `'docker pull archlinux/base'`
1. Create a fresh controller container:
   * `'cd ./files/docker/controller/ && docker build --tag control . && cd ~/homefarm'`
1. Unpack the backup and restore the local repo: `'./bin/farmctl restore ~/homefarm'`
1. Start the controller and run `init` to finalize setup:
   * `'./bin/farmctl up'`
   * `'farmctl init'`
1. Exit the controller, then bring it back up to ensure a known state

At this point, everything should be good and all commands should give
the expected results.
