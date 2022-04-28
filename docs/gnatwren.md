# Using Gnatwren

Homefarm integrates with a lightweight monitoring service (also
written by myself) named Gnatwren. If you'd like to use it, it's very
simple to get going.

## Installing

- Follow the [Gnatwren](https://github.com/firepear/gnatwren) Docker
  install instructions to stand up an instance of `gwgather` (the data
  collection and reporting portion of Gnatwren)
  - This will be separate from your Homefarm container, and will not
    interact with it.
- While attached to the `farmctl` container, do:
  - `ansible-playbook gnatwren.yml`
  - Edit `./files/gwagent-config.json` to point at the IP of the
    machine where the `gwgather` container is running
  - Rerun the gnatwren playbook (sorry for this kludge)

You should then be able to visit `http://GWGATHER_IP:9098/` and
see current stats about your farm. See the Gnatwren docs for more
info.

## Updating Gnatwren or its configuration

If there is a new version of Gnatwren, rebuild the `gwgather`
container as described above.

Rerun `ansible-playbook gnatwren.yml` anytime to rebuild and re-deploy
the agent software if there have been changes.

Similarly, edit `./files/gwagent-config.json` and rerun the playbook
to push configuration changes to your nodes.
