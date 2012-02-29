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

function einfo()
{
    echo -e " ${GOOD}*${NORMAL} ${@}"
}

function ewarn()
{
    echo -e " ${WARN}*${NORMAL} ${@}"
}

function eerror()
{
    echo -e " ${BAD}*${NORMAL} ${@}"
}

function ebegin()
{
    echo -e " ${GOOD}*${NORMAL} ${@} ..."
}

function eend()
{
    # ncurses dependency
    COLUMNS=$(/usr/bin/tput cols)
    curpos row
    ROW=$?
    ROW=$((ROW - 2))
    COL=$((COLUMNS - 6))
    /usr/bin/tput cup "${ROW}" "${COL}"
    if [ "$1" != 1 ]; then
	echo -e "${BRACKET}[${NORMAL} ${GOOD}ok${NORMAL} ${BRACKET}]${NORMAL}"
    else
	echo -e "${BRACKET}[${NORMAL} ${BAD}!!${NORMAL} ${BRACKET}]${NORMAL}"
    fi
}

export -f einfo ewarn eerror ebegin eend curpos
