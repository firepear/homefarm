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
        echo 0
    else
        echo 1
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

terminate() {
    echo
    echo "${1}. Terminating install."
    echo
    exit 1
}

findmac() {
    IFACES=( $(ls /sys/class/net) )
    for if in ${IFACES}
    do
        if [[ ${if} != "lo" ]]; then
            IFNAME=${if}
        fi
    done
    MAC=$( cat /sys/class/net/"${IFNAME}"/address )
    echo "${IFNAME} ${MAC}"
}
