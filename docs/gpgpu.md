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

I have noticed that Nvidia drivers _frequently_ lag behind kernel
updates by a day or so in Arch. I don't have any visibility into why
this is the case, but I have seen it very consistently over the past
year.

If you noticed that you have GPGPU WUs in state `Paus` after a system
update, then you are likely experiencing this issue. You can confirm
it by doing `'ssh farmer@NODENAME nvidia-smi'`. If you get the
response:

`NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver. Make sure that the latest NVIDIA driver is installed and running.`

Then you're looking at this issue, where the kernel version and the
Nvidia drivers are out of sync. Eventually the packages will sync back
up (usually in a day). You can either do another `farmctl update`, or
just tell the affected nodes to upgrade their packages directly with
`'ssh farmer@NODENAME "sudo pacman -Syu"'`.
