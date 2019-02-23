# Backing up farm state/Reinstalling the control node

As always, cd to `~/homefarm`.

Under Homefarm, compute nodes are fungible. We don't care about them;
we only care about their workunits. The control node is different
though, since it stores the unique configuration of our farm. The
`backup` utility helps with this.

`'./bin/backup'`

This will create a tarball containing every piece of local
configuration for your farm. (Assuming you've been following the
directions in these docs! If you go off piste, you're on your own!)

Move this tarball somewhere safe, like another server, or an S3
bucket, or dropbox. Update it whenever you'd like. After a control
node reinstall, get the tarball back on the control node and run:

`'./bin/backup --restore'`

It will unpack the archive and move things to their correct
locations. You'll be able to ssh into all your compute nodes, you
won't have to generate a new mirrorlist, and so on.

The local mirror will need to rebuild itself, though, so the first
time you run `./bin/update` after reinstalling the control node will
take much longer than usual.
