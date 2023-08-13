# GPGPU on Homefarm

Homefarm's compute node setup installs the packages needed for OpenCL
and CUDA computing, so your nodes should be ready for GPGPU usage once
install is complete.

## BOINC

If you're adding GPU capablity to a project the machines are already
attached to, you don't need to do anything from within Homefarm. The
machines should start picking up GPGPU work on the next project
update. If you need that to happen immediately, you can force it by
running:

`farmctl cmd 'sudo systemctl restart boinc-client`

If you're adding a new project, there's nothing special about it. Edit
the `<NODE>.yml` file as you normally would to add a project, and then
run `farmctl project-sync`.

### Nvidia and updates

If you noticed that you have GPGPU WUs in state `Paus` after a system
update, then trydoing `'ssh farmer@NODENAME nvidia-smi'`. If you get
the response:

```
NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver.
Make sure that the latest NVIDIA driver is installed and running.
```

Then your kernel version and the Nvidia drivers are out of sync. This
happens when a mirror has significant lag and is not keeping itself in
sync with the Arch master repo.

- Go to https://www.archlinux.org/mirrors/status/#successful
- Find a geographically-close mirror with low lag
- Edit its URL into `srv/homefarm/mirrorlist` and `./.fpconfig.json`
- Run `farmctl update`.


## Folding@Home

Coming soon...

## GPU power settings

Homefarm supports setting GPU power limits at boot (Nvidia only at the
present time). In fact, by default, Nvidia GPUs will have their power
limited to 110W. To change this, edit the file
`nodes/[NODENAME]_sys_config.json` and change the `pl` value. Then run
`farmctl update`.
