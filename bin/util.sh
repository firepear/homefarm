shownotice () {
    charcount=$(( 79 - ${#1} ))
    echo
    for x in $(seq 1 ${charcount}); do
        echo -n '-'
    done
    echo " ${1}"
}
