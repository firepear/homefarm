# Update fixes

Sometimes Arch breaks packages. Sometimes Homefarm has bugs. Sometimes
you need to do a fix to unbreak an OS update. This is how to do those.

Please file an issue if you can't find an answer to your problem.


## `farmctl status` can't connect after `farmctl update`

_Note: This should no longer occur. Please file an issue if you see
this._

BOINC was probably upgraded, and the custom Homefarm service file was
overwritten.

Run `farmctl boinc-config` and see if `status` works afterward.




## 2019-12-21 Arch linux uses `wlan0` during install

If this happes to you, don't fret. A few simple fixes will take care
of everything and then you'll be on your way.

Try this first:

1. Systemd will wait 1m30s for `wlan0` to become available. Wait
   through this, then login as root
1. Run `'ip addr`' to see the correct interface name
1. `'curl -O CONTROLLER_IP:9099/fix-wlan0'`
1. `'/bin/bash fix-wlan0 IFACE'`
1. Reboot

If the system comes up as expected, go back to the previous doc and
continue with "Homefarm setup". If not, here's the manual fix:

1. Do `'ip addr'` to see what wireless interface exists now. Probably
   something like `wlp5s0`
1. Run `'mv /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
   /etc/wpa_supplicant/wpa_supplicant-[IFACE].conf'`
1. Use `vi` or `mg` to edit
   `/etc/systemd/network/25-wireless.network`. Change the interface
   name in the first stanza
1. Run:
   * `'systemctl disable wpa_supplicant@wlan0'`
   * `'systemctl disable wpa_supplicant@[IFACE]'`
1. Reboot

Now pick back up where you left off in the previous doc, with "Homefarm setup".




## 2019-03-09 pip ansible update breakage

This was the impetus for moving Homefarm to the Arch ansible
package. To get things in line, run the following commands on the
control node, from `~/homefarm`, as usual.

```
export sshcmd='pip uninstall ansible'; for node in nodes/node*yml; \
    do node=$(basename "${node}" .yml); echo "${node}";\
    ssh farmer@${node} "sudo ${sshcmd}"; done

export sshcmd='rm -rf /usr/lib/python3.7/site-packages/PyYAML-3.13-py3.7.egg-info'; for node in nodes/node*yml; \
    do node=$(basename "${node}" .yml); echo "${node}"; \
    ssh farmer@${node} "sudo ${sshcmd}"; done

export sshcmd='pacman -S --overwrite '"'"'*'"'"' ansible'; for node in nodes/node*yml; \
    do node=$(basename "${node}" .yml); echo "${node}"; \
    ssh farmer@${node} "sudo ${sshcmd}"; done

sudo pip uninstall ansible
sudo rm -rf /usr/lib/python3.7/site-packages/PyYAML-3.13-py3.7.egg-info
sudo pacman -S --overwrite '*' ansible
```

Now run `./bin/update` to make sure your Homefarm install is up to
date and get everything upgraded.
