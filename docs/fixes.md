# Update fixes

Sometimes Arch breaks packages. Sometimes Homefarm has bugs. Sometimes
you need to do a fix to unbreak an OS update. This is how to do those.

## 2019-03-09 pip ansible update breakage

This was the impetus for moving Homefarm to the Arch asible
package. To get things in line, run the following commands from the
control node, as usual.

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
