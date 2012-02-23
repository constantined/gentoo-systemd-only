# Copyright (c) 2012 Canek Peláez Valdés <canek@ciencias.unam.mx>
# Compatibility e* log functions for gcc-config

_e_log()
{
	printf "$@"
}

eerror()
{
	_e_log "$@"
}

ewarn()
{
	_e_log "$@"
}

ebegin()
{
	_e_log "$@"
}

eend()
{
	_e_log "\n"
}
