# Backing up farm state/Reinstalling the control node

As always, cd to `~/homefarm`.

Under Homefarm, compute nodes are fungible. We don't care about them;
we only care about their workunits. The control node is different
though, since it stores the unique configuration of our farm. The
`backup` utility helps with this.

## Backup the farm

`'./bin/backup'`

This will create a tarball containing every piece of local
configuration for your farm. (Assuming you've been following the
directions in these docs! If you go off piste, you're on your own!)

Move this tarball somewhere safe, like another server, or an S3
bucket, or dropbox. Update it whenever you'd like.

## Recovering a control node

Do the first five steps detailed in the [control node install
doc](https://github.com/firepear/homefarm/blob/master/docs/control_install.md).

After that, reboot the Pi, login, and cd to `~/homefarm`.  Copy the
archive file onto the control node and into `~/homefarm`. Then restore
the farm configuration from the archive:

`'./bin/backup --restore'`

And rebuild the local Arch repository:

`'export MIRROR_URL=$(cat .mirror_url) && ./bin/update --set-mirror "${MIRROR_URL}"'`

The control node should now be back to the state it was in before the
reinstall.
