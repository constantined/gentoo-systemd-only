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
        GOOD=$(printf '\e[1;32m')
	WARN=$(printf '\e[1;33m')
	BAD=$(printf '\e[1;31m')
	HILITE=$(printf '\e[1;36m')
	BRACKET=$(printf '\e[1;34m')
	NORMAL=$(printf '\e[0;0m')
    fi
fi

_e_log()
{
	printf "$@"
}

eerror()
{
	_e_log " ${BAD}*${NORMAL} $@\n"
}

ewarn()
{
	_e_log " ${WARN}*${NORMAL} $@\n"
}

ebegin()
{
	_e_tmp_msg="$@"
	_E_LOG_EBEGIN_STR_LEN=${#_e_tmp_msg}
	_E_LOG_EBEGIN_STR_LEN=$((_E_LOG_EBEGIN_STR_LEN + 3)) # ' * ' prefix
	export _E_LOG_EBEGIN_STR_LEN
	_e_log " ${GOOD}*${NORMAL} $@"
}

eend()
{
	# ncurses dependency
	COLUMNS=$(/usr/bin/tput cols)
	if [ -z "${_E_LOG_EBEGIN_STR_LEN}" ]; then
		_E_LOG_EBEGIN_STR_LEN=0
	fi
	_e_tmp_needed_spaces=$((COLUMNS - _E_LOG_EBEGIN_STR_LEN - 6))
	unset _E_LOG_EBEGIN_STR_LEN
	if [ "${_e_tmp_needed_spaces}" -lt 0 ]; then
		_e_tmp_needed_spaces=0
	fi
	_e_tmp_spaces=""
	_e_tmp_c=0
	while [ "${_e_tmp_c}" -lt "${_e_tmp_needed_spaces}" ]; do
		_e_tmp_spaces="${_e_tmp_spaces} "
		_e_tmp_c=$((_e_tmp_c + 1))
	done
	if [ "$1" == 0 ]; then
		_e_log "${_e_tmp_spaces}${BRACKET}[${NORMAL} ${GOOD}OK${NORMAL} ${BRACKET}]${NORMAL}\n"
	else
		_e_log "${_e_tmp_spaces}${BRACKET}[${NORMAL} ${BAD}!!${NORMAL} ${BRACKET}]${NORMAL}\n"
	fi
}

einfo()
{
	_e_log " ${GOOD}*${NORMAL} $@\n"
}
