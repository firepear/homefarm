## Build and initialize BOINC on the nodes

When all compute nodes have been installed, return to the control node
and:

1. Run `'ansible-playbook compute-nodes-boinc.yml'` to build and start
   BOINC on the compute nodes, and to generate sample configs for all
   defined compute nodes
1. If you want to make BOINC configuration changes, edit the
   `cc_[NODE_NAME].xml` file (in the `nodes` directory) for the node
   you wish to change
     * This file is the standard BOINC `cc_config.xml` file, and will
       have that name when installed on the compute node
     * Add whatever [BOINC config
       directives](https://boinc.berkeley.edu/wiki/Client_configuration)
       you would like
     * If you want multiple nodes with identical configurations,
       delete the config files for the duplicate nodes and make
       symlinks to the desired config.
1. Edit the node configs (`[NODE_NAME].yml` in the `nodes` directory) to
   declare what BOINC projects you want each node to attach to.
     * Edit the placeholder `PROJ_URL`, `PROJ_EMAIL_ADDR`, and
       `PROJ_PASSWORD` values for each project
     * Change the project `status` if you'd like
     * Add/delete stanzas as needed
     * If you want multiple nodes with identical configurations,
       delete the config files for the duplicate nodes and make
       symlinks to the desired config
1. Run `'ansible-playbook update-projects.yml'` to attach nodes to
   projects

Your compute farm should then begin communicating with the servers of your
projects, and start crunching workunits!
