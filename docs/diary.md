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


## 2019-01-12

Instead of proceeding with the aforementioned work, I randomly decided
to make some improvements to the installer. Not really randomly -- I'd
been thinking about them, but they weren't on an issue or anything.

Anyway, the installer is better now, in some minor ways.

* I imported the hardware clock check from the old inkubator installer.

* I moved the TZ configuration so that it actually has an effect -- it
  had been operating on the install environment, rather than the OS
  being installed. Oops.

* I made the setup script auto-configure lm_sensors

I'm not actually interested in the `sensors` binary, but the modules
which are enabled by configuring the lm_sensors package are what gets
a lot of temperature and fan data into sysfs. And I am interested in
having that data available via sysfs.

These changes are the basis of v0.14.0, which will be cut as soon as
one of my nodes finishes all its current tasks so I can do a reinstall
for testing.


## 2019-01-13

Decided to make one more back-burnered improvement before testing last
night's installer changes: if the user follows the install
instructions and uses the `wpa_supplicant` file named there when
configuring their wireless, then they don't have to pass the `ESSID`
and `WPA_PASSWD` to the installer script.


## 2019-01-17

I'm really on a roll this week. No reason not to push on and head
toward 1.0.0 though.

I'm just about to cut v0.15.0, whose big win is logfile rotation. No
more BOINC jobfiles and daemon logs slowly piling up forever. Those
files grow pretty slowly, but they're still a recipe for wondering why
everything quit working on a random day 30 months after you set up
your cluster.

This closes out the first issue I ever filed for homefarm, back on
September 17th -- 4 months ago to the day. Nice.

The smaller issues cleared up in this release are that the alarm
account on the control node will now have passwordless sudo access
(for new installs, anyway), and that compute nodes now get a random
root password set on setup (previously it was left at the default of
'root').

The latter is just to make me feel less guilty. The former is to make
update run with no prompts.

There's nothing left on the punchlist for 1.0 now, except setting up a
local repository on the control node, and pointing the compute nodes
at it for installation and updates. This one will take a little work,
but not too much. It will require yet another reinstall of node01 to
fully test, though. I'll live. Luckily, I wrote this pile of scripts
to help me install and manage compute nodes!
