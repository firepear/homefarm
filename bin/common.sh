#!/bin/bash
shownotice () {
    charcount=$(( 79 - ${#1} ))
    echo
    for x in $(seq 1 ${charcount}); do
        echo -n '-'
    done
    echo " ${1}"
    echo
}

affirmative() {
    RESPONSE=""
    read -r -p "${1} (y/N)? " RESPONSE
    if [[ "${RESPONSE^^}" =~ ^Y ]]; then
        echo "true"
    else
        echo "false"
    fi
}

gutcheck() {
    if [[ "${2}" = "" ]]; then
        PROMPT="${1}: "
    else
        PROMPT="${1} (default is '${2}'): "
    fi

    ASKAGAIN="n"
    while [[ ! "${ASKAGAIN^^}" =~ ^Y ]]
    do
        read -r -p "${PROMPT}" GUTCHECK
        # return the default if one was provided and the user just hit
        # enter
        if [[ "${2}" != "" ]] && [[ "${GUTCHECK}" == "" ]]; then
            echo "${2}"
            return
        fi
        read -r -p "You entered '${GUTCHECK}'. Is this correct (y/N)? " ASKAGAIN
    done
    echo "${GUTCHECK}"
}

hf_setarch() {
    CPUARCH=$(grep Arch /etc/pacman.conf | cut -d' ' -f3)
    if [[ "${CPUARCH}" == "auto" ]]; then
        CPUARCH="x86_64"
    fi
    echo "${CPUARCH}"
}


hf_fetch() {
    err=$(curl --connect-timeout 10 --speed-time 10 --speed-limit 1024 -f -s -S -O "${1}" 2>&1)
    rc=${?}
    if [[ "${rc}" != "0" ]]; then
        echo "error: couldn't fetch '${1}'. problem was:"
        echo "${err}"
        exit ${rc}
    fi
}

hf_docker_test() {
    if grep docker /proc/1/cgroup > /dev/null; then
        echo "This command can't be run inside the Homefarm container."
        exit
    fi
}

update_localrepo() {
    repodir="${1}"
    mirrorurl="${2}"
    arch="${3}"
    repodir="${repodir}/${arch}"
    firstnode="${4}"

    # grab core db file from mirror and test it against the last
    # hash. do nothing if they match.
    mkdir -p "${repodir}"
    cd "${repodir}" || exit
    hf_fetch "${mirrorurl}/core/os/${arch}/core.db.tar.gz"
    coremd5=$(md5sum core.db.tar.gz)
    if [[ -e "prevmd5" ]]; then
        prevmd5=$(cat prevmd5)
        if [[ "${prevmd5}" == "${coremd5}" ]]; then
            rm core.db.tar.gz
            return
        fi
    fi
    echo "${coremd5}" > prevmd5

    shownotice "Updating local mirror"
    # generate and grab installed packages list
    mkdir -p "${repodir}/db"
    if [[ "${firstnode}" == "" ]]; then
        # this branch runs during control node install and uses the
        # initial packages list
        cp "${FP_CONFIG[rootdir]}/files/pkgs-${arch}.txt" ./db/pkgs.txt
    else
        # this branch runs during normal update. it grabs a package
        # list from the first node and sets localrepo_updated to true,
        # which will trigger OS updates on the compute nodes
        ssh -o StrictHostKeyChecking=accept-new "farmer@${firstnode}" 'sudo pacman -Qi | grep Name | awk '"'"'{print $3}'"'"' > pkgs.txt'
        # scp node pkgs to the repodir
        scp -q "farmer@${firstnode}:pkgs.txt" "${repodir}/nodepkgs.txt"
        # merge the node pkgs and the initial homefarm pkgs
        cat "${FP_CONFIG[rootdir]}/files/pkgs-${arch}.txt" "${repodir}/nodepkgs.txt" | sort | uniq > "${repodir}/db/pkgs.txt"
        export localrepo_updated="true"
    fi
    # grab remaining db files from mirror, and unpack all of them
    echo "Updating package databases"
    for repo in core extra community; do
        cd "${repodir}" || exit
        if [[ ! -e "${repo}.db.tar.gz" ]]; then
            hf_fetch "${mirrorurl}/${repo}/os/x86_64/${repo}.db.tar.gz"
        fi
        mkdir -p "${repodir}/db/${repo}"
        mv "${repo}.db.tar.gz" "${repodir}/db/${repo}"
        cd "${repodir}/db/${repo}" || exit
        tar zxvf "${repo}.db.tar.gz" > /dev/null 2>&1
        rm "${repo}.db.tar.gz"
    done
    cd "${repodir}" || exit
    # call the python script which manages all the repo files
    /homefarm/bin/repo-update "${repodir}" "${mirrorurl}"
    if [[ "${?}" != "0" ]]; then
        exit 1
    fi
    # delete the db files and the installed package list
    rm -rf "${repodir}/db"
    # rebuild the local repo index
    echo "Building repo index (this may take a moment)"
    repo-add -n -R "${repodir}/arch.db.tar.gz" "${repodir}"/*.pkg.* >> update.log 2>&1
    cd /homefarm || exit
}

# fp_parseconfig parses a JSON configuration file and stores its
# contents in the variable FP_CONFIG.
#
# it takes a minimum of two arguments. the first is the path to the
# configuration file to be parsed. the second (and any further)
# arguments are spliced together to form the JSON 'path' which will be
# extracted.
#
# this means that your config must have a top-level object, perhaps
# named after your program or project, which contains the
# configuration for that program or project.
#
# the contents of that object should not contain nested data. this
# means that objects-of-objects are impossible to represent, and that
# lists should be represented by separating values with '::'.
fp_parseconfig() {
    # check for the existance of `jq`
    echo '{}' | jq > /dev/null
    rc="${?}"
    if [[ "${rc}" != "0" ]]; then
        echo "error: can't find command 'jq'; please install and re-run. exiting"
        exit 1
    fi

    # our first argument is our config file. assign it and take it off
    # the list
    conf="${1}"
    shift

    # the remaining arguments are going to be the part of the config
    # file we want to extract. assemble them into a period-delimited
    # string, starting with a period, to pass to 'jq'
    param=""
    for arg in ${@}; do
        param="${param}.${arg}"
    done
    # call jq, trim curly braces, and use awk to remove spaces. then
    # do processing and store the values.
    for line in $(jq "${param}" < "${conf}" | tail +2 | head -n -1 | awk '{ print $1$2 }'); do
        # use ${param%word} expansion to trim trailing commas
        line="${line%,}"
        # extract key and value
        key=$(echo "${line}" | cut -d: -f1)
        val=$(echo "{ ${line} }" | jq ".${key}")
        # use ${param/pattern/string} expansion to remove all quotes
        key="${key//\"/''}"
        val="${val//\"/''}"
        # if value contains '::', change them into spaces for future
        # iteration as a list
        val="${val//::/ }"
        # store in array
        FP_CONFIG[$key]="${val}"
    done
}
