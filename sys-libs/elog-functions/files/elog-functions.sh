# Copyright (c) 2012 Canek Peláez Valdés <canek@ciencias.unam.mx>
# Compatibility e* log functions for gcc-config

NORMAL='\e[0;0m'
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'

_e_log()
{
	printf "$@"
}

eerror()
{
	_e_log " ${RED}*${NORMAL} $@\n"
}

ewarn()
{
	_e_log " ${YELLOW}*${NORMAL} $@\n"
}

ebegin()
{
	_e_log " ${GREEN}*${NORMAL} $@"
}

eend()
{
	if [ "$1" == 0 ]; then
		_e_log "\t${BLUE}[${NORMAL} ${GREEN}OK${NORMAL} ${BLUE}]${NORMAL}\n"
	else
		_e_log "\t${BLUE}[${NORMAL} ${RED}!!${NORMAL} ${BLUE}]${NORMAL}\n"
	fi
}

einfo()
{
	_e_log " ${GREEN}*${NORMAL} $@\n"
}
