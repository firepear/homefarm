# Enabling GPGPU projects

Homefarm itself doesn't know anything about GPGPU computing, or your
video card. But it also doesn't care -- so just manually install a few
packages to enable OpenCL/CUDA support, and you'll be good to go.

On each machine you wish to be GPGPU-enabled, run:

`'sudo pacman -S nvidia opencl-nvidia ocl-icd'`

if you have an Nvidia card, or:

`'sudo pacman -S opencl-mesa ocl-icd'`

for AMD GPUs.

After a reboot, BOINC should see the GPU as usable. Once it does, just
define the project like any other in
`/home/alarm/homefarm/nodes/[NODE_NAME].yml` on the controller, then
run the `update-projects` playbook.

The update script will keep the GPGPU packages up to date along with
everything else.
