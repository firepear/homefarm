# Enabling GPGPU projects

Homefarm itself doesn't know anything about GPGPU computing, or your
video card. But it also doesn't care -- so just manually install a few
packages to enable OpenCL/CUDA support, and you'll be good to go.

For each machine you wish to be GPGPU-enabled, login as
`farmer`. Then, for Nvidia GPUs, run:

`'sudo pacman -S nvidia opencl-nvidia ocl-icd'`

Or for AMD GPUs:

`'sudo pacman -S opencl-mesa ocl-icd'`

And reboot. BOINC should see the GPU as usable.

If you're adding GPU capablity to a project the machines are already
attached to, you don't need to do anything on the controller side. The
machines should start picking up GPGPU work on the next project
update.

If you're adding a new project, there's nothing special about it. Just
edit the `<NODE>.yml` file as you normally would to add the project,
and then run `farmctl project-sync`.

## Note on Nvidia and updates

If you noticed that you have GPGPU WUs in state `Paus` after a system
update, then trydoing `'ssh farmer@NODENAME nvidia-smi'`. If you get
the response:

`NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver. Make sure that the latest NVIDIA driver is installed and running.`

Then yourkernel version and the Nvidia drivers are out of sync. This
happens when a mirror has significant lag and is not keeping itself in
sync with the Arch master repo. Go to
https://www.archlinux.org/mirrors/status/#successful and find a
geographically-close mirror with low lag. Edit its URL into
`srv/homefarm/mirrorlist` and `./.fpconfig.json`, then re-run `farmctl
update`.
