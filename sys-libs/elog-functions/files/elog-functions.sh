# Copyright (c) 2012 Canek Peláez Valdés <canek@ciencias.unam.mx>
# Compatibility e* log functions from sys-apps/openrc

# Shamelessly stolen from /etc/init.d/functions.sh
for arg; do
    case "$arg" in
        --nocolor|--nocolour|-C)
	    export EINFO_COLOR="NO"
	    ;;
    esac
done

# Adapted from /etc/init.d/functions.sh so we don't need eval_colors
if [ "${EINFO_COLOR}" != NO ]; then
    if [ -z "$GOOD" ]; then
        GOOD=$(echo -ne "\e[1;32m")
	WARN=$(echo -ne "\e[1;33m")
	BAD=$(echo -ne "\e[1;31m")
	HILITE=$(echo -ne "\e[1;36m")
	BRACKET=$(echo -ne "\e[1;34m")
	NORMAL=$(echo -ne "\e[0;0m")
	export GOOD WARN BAD HILITE BRACKET NORMAL
    fi
fi

# Hack to get terminal cursor position. I believe it's OK to use it
# since OpenRC uses terminal escape sequences anyhow
function curpos()
{
    echo -ne "\e[6n"
    read -sdR CURPOS
    CURPOS=${CURPOS#*[}

    c=0
    for e in $(echo $CURPOS | tr ";" "\n"); do
	arr[c]="${e}"
	c=$((c + 1))
    done

    case "$1" in
	"row")
	    return "${arr[0]}"
	    ;;
	"col")
	    return "${arr[1]}"
	    ;;
	*)
	    return "${CURPOS}"
	    ;;
    esac

    return "${CURPOS}"
}

function elog()
{
    if [ "${EINFO_QUIET}" == "true" ]; then
	return
    fi
    echo -ne "${@}"
}

function errlog()
{
    echo -ne "${@}" > /dev/stderr
}

function einfo()
{
    elog " ${GOOD}*${NORMAL} ${_ELOG_INDENT}${@}\n"
}

function ewarn()
{
    errlog " ${WARN}*${NORMAL} ${_ELOG_INDENT}${@}\n"
}

function eerror()
{
    errlog " ${BAD}*${NORMAL} ${_ELOG_INDENT}${@}\n"
}

function veinfo()
{
    if [ "${EINFO_VERBOSE}"  == "true" ]; then
	einfo "${@}"
    fi
}

function vewarn()
{
    if [ "${EINFO_VERBOSE}" ]; then
	ewarn "${@}"
    fi
}

function ebegin()
{
    elog " ${GOOD}*${NORMAL} ${_ELOG_INDENT}${@} ...\n"
}

function ebracket()
{
    COLUMN="$1"
    COLOR="$2"
    MSG="$3"
    curpos row
    ROW=$?
    ROW=$(($? - 2))
    /usr/bin/tput cup "${ROW}" "${COLUMN}"
    echo -e "${BRACKET}[${NORMAL} ${COLOR}${MSG}${NORMAL} ${BRACKET}]${NORMAL}"
}

function eend()
{
    if [ "${EINFO_QUIET}" == "true" ]; then
	return
    fi
    msg="$1"
    if [ ! -z "${msg##*[!0-9]*}" ]; then
	retval="$msg"
    else
	eerror "$msg"
	retval=1
    fi
    # ncurses dependency
    COLUMNS=$(/usr/bin/tput cols)
    COLUMN=$((COLUMNS - 6))
    curpos row
    ROW=$?
    ROW=$((ROW - 2))
    LBRAC="${BRACKET}[${NORMAL}"
    RBRAC="${BRACKET}]${NORMAL}"
    /usr/bin/tput cup "${ROW}" "${COLUMN}"
    if [ "$retval" != 1 ]; then
	echo -e "${LBRAC} ${GOOD}ok${NORMAL} ${RBRAC}"
    else
	echo -e "${LBRAC} ${BAD}!!${NORMAL} ${RBRAC}"
    fi
}

function eindent()
{
    if [ -z "${_ELOG_INDENT}" ]; then
	export _ELOG_INDENT="  "
    else
	export _ELOG_INDENT="${_ELOG_INDENT}  "
    fi
}

function eoutdent()
{
     if [ -z "${_ELOG_INDENT}" ]; then
	 unset _ELOG_INDENT
     else
	 export _ELOG_INDENT=$(echo "${_ELOG_INDENT}" | sed "s/  //")
     fi
}

export -f elog errlog einfo ewarn eerror veinfo vewarn ebegin eend eindent eoutdent curpos
