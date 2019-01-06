# Dev diary

## 2018-12-25

The past few days have been all about migrating from Alpine Linux to
Arch Linux.

I loved Alpine's compactness, security focus, and use of openrc
init. Unfortunately, there were two problems with Alpine that I
couldn't work through:

* A minor issue was the LTS kernel, which was too old to know how to
  talk to k10 temperature sensors on Ryzen CPUs
    * This was slated to be resolved in the next release, but there
      was no word on when that would be
* Less minor was the fact that Alpine's orientation toward servers and
  containers is so focused that it's hugely painful to install Nvidia
  drivers

I'd like to not need Nvidia drivers. It would be nice if everyone
wrote OpenCL code for their GPGPU projects. The truth, though, is that
Nvidia and CUDA are so entrenched that some projects (like GPUGrid)
are Nvidia-only. So if I want Homefarm to support GPGPU -- even
indirectly, which is the plan -- then getting Nvidia cards working
under BOINC needs to be easy.

So after a long weekend, that's where I'm at.

* My three compute nodes (and my control node) have all been
  reinstalled and are running Arch Linux now.
* Sensors (and sysfs temperature data) are available.
* My trusty old GTX 750 Ti is cranking on PrimeGrid and GPUGrid WUs
  again.

The conversion isn't quite complete. The `update-farm` script needs a
rewrite; moving to Arch brings some different assumptions. After that
I think everything will be changed over and I'll overhaul the
docs. Then 0.13.0 will be cut.


## 2018-12-29

Been sick most of the week. Reinstalled my personal laptop today,
following an upgrade of the SSD. It's running Arch as well now, and
the `compute-install` script did the heavy lifting.

That resulted in a couple of bugfixes

* The call to `parted` which gathered current partition maps would
  fail if a device had no recognizable partition map
* The `base-devel` group is now installed at pacstrap time

and an idea

* It's possible to use the existance of a wpa_supplicant configuration
  file to obviate the need to supply ESSID and WPK to the installer
  script

Update script work will resume once I'm back to 100%.


## 2019-01-06

Wrapped up the Arch work yesterday and pushed v0.13.0 out the
door. Then, late last night, tagged v0.13.1 because I made so many
tweaks in the hours following. I should really let things sit for a
bit before tagging releases.

Used a couple of useful ansible commands to play around with some
stuff. Got lm_sensors on all my machines after adding it to the
`pacstrap` list with

`ansible compute_nodes --become -m pacman -a "name=lm_sensors state=present"`

And then checked temps on everything with

`ansible compute_nodes -a "/usr/bin/sensors"`

...but I have better plans for that sort of thing. That's for
post-v1.0 though.

Speaking of v1.0, I've declared issues #1, #9, and #12 the blockers
for that release. I want to get to work on local repositories, but
making the BOINC logs rotate is a much lower-hanging piece of fruit,
so I'll do that next.
