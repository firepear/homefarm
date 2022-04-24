# Using Gnatwren

Homefarm has support for a lightweight monitoring service (also
written by myself) named Gnatwren. If you'd like to use it, it's very
simple to get going.

- Check out the [Gnatwren
  README](https://github.com/firepear/gnatwren) and follow the Docker
  install instructions to stand up an instance of `gwgather` (the data
  collection and reporting portion of Gnatwren)
- From inside the `farmctl` shell, do:
  - `ansible-playbook --extra-vars "hfarch=x86_64" gnatwren.yml`
  - Edit `gwagent-config.json` to point at the IP of the machine where
    the `gwgather` container is running
  - Rerun the gnatwren playbook (sorry for this kludge)

After that, you should be able to visit `http://GWGATHER_IP:9098/` and
see current stats about your farm. See the Gnatwren docs for more
info.
