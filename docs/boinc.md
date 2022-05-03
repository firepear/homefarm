# Managing BOINC

## Adding/removing/modifying BOINC projects

Edit `nodes/<NODE_NAME>.yml` for any nodes you wish to modify.

* To define and attach to a new project, create a new stanza in the
  `projects` dict and set the project state to `active`
* To suspend work on a project, set project state to `suspended`
* To resume work on a project, set project state to `active`
* To finish the workunits you have, but not request more, set project state to `nomorework`
* To restart work from a state of `nomorework`, set project state to `active`
* To detach from a project entirely, set project state to `detached`.
  * There is no reason to remove detached project stanzas unless you
    wish to clean up the file, and leaving them in place makes it easy
    to re-attach later. You can also comment them out.

Run `farmctl project-sync` to have the changes pushed out to
the node(s).

To change the user a node is running a project as:

* Set project state to `detached`
* Run  `'farmctl project-sync'`
* Update the user info and set the state to `active`
* Re-run  `'farmctl project-sync'`

## Configuring BOINC itself

Edit `nodes/<NODE_NAME>-cc.xml` for any nodes you wish to modify. Add
and/or update whatever [BOINC config
directives](https://boinc.berkeley.edu/wiki/Client_configuration) you
would like.

Run `farmctl project-sync` to push the changes out to the nodes.

## Configuring individual BOINC projects

Homefarm allows per-node, per-project configuration, as supported by
the BOINC standard `app_config.xml` file.

For each project you wish to have a configuration, create or edit the
file `nodes/<NODE_NAME>-app_config-<PROJECT_URL>.xml`

`PROJECT_URL` must match the URL defined in the node's project list in
`nodes/<NODE_NAME>.yml`. A concrete example:

`node02-app_config-www.worldcommunitygrid.org.xml`

Add whatever [project configuration
directives](https://boinc.berkeley.edu/wiki/Client_configuration#Project-level_configuration)
you would like.

Run `farmctl project-sync` to push the changes out to the nodes.

## Connecting to compute nodes

After installation, there are two login accounts on each compute node:
`root`, and `farmer`.

The `farmer` account is used by Ansible, and may be used for anything
you'd like. It has full, passwordless `sudo` access. The password for
`farmer` is set to a randomized string, which is not recorded during
the install process. To login as `farmer`, from the controller:

`ssh farmer@NODE_NAME`

The `root` password is either randomized, or set to the value provided
during installation. SSH access is disabled. The intent is to either
not use root at all, or use it only for emergency maintenance with
physical access.




