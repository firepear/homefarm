#!/bin/bash
shownotice () {
    charcount=$(( 79 - ${#1} ))
    echo
    for x in $(seq 1 ${charcount}); do
        echo -n '-'
    done
    echo " ${1}"
    echo
    sleep 1
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

hf_fetch() {
    err=$(curl --connect-timeout 10 --max-time 60 -s -S -O "${1}" 2>&1)
    rc=${?}
    if [[ ${rc} -ne 0 ]]; then
        echo "error: couldn't fetch '${1}'. problem was:"
        echo "${err}"
        exit ${rc}
    fi
}

update_localrepo() {
    repodir=${1}
    mirrorurl=${2}
    firstnode=${3}
    # grab core db file from mirror and test it against the last
    # hash. do nothing if they match.
    cd "${repodir}" || exit
    hf_fetch "${mirrorurl}/core/os/x86_64/core.db.tar.gz"
    coremd5=$(md5sum core.db.tar.gz)
    if [[ -e "prevmd5" ]]; then
        prevmd5=$(cat prevmd5)
        if [[ "${prevmd5}" == "${coremd5}" ]]; then
            rm core.db.tar.gz
            return
        else
            export localrepo_updated="true"
        fi
    fi
    echo "${coremd5}" > prevmd5

    shownotice "Updating local mirror"
    # generate and grab installed packages list
    mkdir -p "${repodir}/db"
    if [[ "${firstnode}" == "" ]]; then
        # this branch runs during control node install
        cp /homefarm/examples/pkgs.txt ./db
    else
        # this branch runs during normal update
        ssh "farmer@${firstnode}" 'sudo pacman -Qi | grep Name | awk '"'"'{print $3}'"'"' > pkgs.txt'
        scp -q "farmer@${firstnode}:pkgs.txt" "${repodir}/db/pkgs.txt"
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
    # delete the db files and the installed package list
    rm -rf "${repodir}/db"
    # rebuild the local repo index
    echo "Building repo index (this will take a while)"
    repo-add -n -R "${repodir}/arch.db.tar.gz" "${repodir}"/*.pkg.tar.xz >> update.log 2>&1
    cd /homefarm || exit
}
