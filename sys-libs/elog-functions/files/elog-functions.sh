# Copyright (c) 2012 Canek Peláez Valdés <canek@ciencias.unam.mx>
# Compatibility e* log functions from sys-apps/openrc

for arg; do
    case "$arg" in
        --nocolor|--nocolour|-C)
	    export EINFO_COLOR="NO"
	    ;;
    esac
done

if [ "${EINFO_COLOR}" != NO ]; then
    if [ -z "$GOOD" ]; then
        GOOD=$(printf "\e[1;32m")
	WARN=$(printf "\e[1;33m")
	BAD=$(printf "\e[1;31m")
	HILITE=$(printf "\e[1;36m")
	BRACKET=$(printf "\e[1;34m")
	NORMAL=$(printf "\e[0;0m")
	export GOOD WARN BAD HILITE BRACKET NORMAL
    fi
fi

function curcol()
{
    echo -en "\e[6n"
    read -sdR CURPOS
    CURPOS=${CURPOS#*[}
	
    c=0
    for e in $(echo $CURPOS | tr ";" "\n"); do
	arr[c]="${e}"
	c=$((c + 1))
    done

    return "${arr[1]}"
}

function einfo()
{
    _e_NL="\n"
    curcol
    if [ "$?" != "1" ]; then
	printf "\n"
	_e_NL=""
    fi
    printf " ${GOOD}*${NORMAL} ${@}${_e_NL}"
}

function ewarn()
{
    _e_NL="\n"
    curcol
    if [ "$?" != "1" ]; then
	printf "\n"
	_e_NL=""
    fi
    printf " ${WARN}*${NORMAL} ${@}\n"
}

function eerror()
{
    _e_NL="\n"
    curcol
    if [ "$?" != "1" ]; then
	printf "\n"
	_e_NL=""
    fi
    printf " ${BAD}*${NORMAL} ${@}\n"
}

function ebegin()
{
    _e_NL="\n"
    curcol
    if [ "$?" != "1" ]; then
	printf "\n"
	_e_NL=""
    fi
    printf " ${GOOD}*${NORMAL} ${@} ..."
}

function eend()
{
    # ncurses dependency
    COLUMNS=$(/usr/bin/tput cols)
    curcol
    CURCOL=$?
    _e_tmp_needed_spaces=$((COLUMNS - CURCOL - 6))
    if [ "${_e_tmp_needed_spaces}" -lt 0 ]; then
	_e_tmp_needed_spaces=0
    fi
    _e_tmp_spaces=""
    _e_tmp_c=0
    while [ "${_e_tmp_c}" -lt "${_e_tmp_needed_spaces}" ]; do
	_e_tmp_spaces="${_e_tmp_spaces} "
	_e_tmp_c=$((_e_tmp_c + 1))
    done
    _e_tmp_n_spaces=${#_e_tmp_spaces}
    if [ "$1" != 1 ]; then
	printf "${_e_tmp_spaces}${BRACKET}[${NORMAL} "
	printf "${GOOD}ok${NORMAL} ${BRACKET}]${NORMAL}\n"
    else
	printf "${_e_tmp_spaces}${BRACKET}[${NORMAL} "
	printf "${BAD}!!${NORMAL} ${BRACKET}]${NORMAL}\n"
    fi
}

export -f einfo ewarn eerror ebegin eend
