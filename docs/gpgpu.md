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
