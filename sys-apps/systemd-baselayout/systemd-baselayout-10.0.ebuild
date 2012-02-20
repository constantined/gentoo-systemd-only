# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

DESCRIPTION="Filesystem baselayout for systemd"
HOMEPAGE="http://xochitl.matem.unam.mx/~canek/gentoo-systemd-only/index.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2
         http://xochitl.matem.unam.mx/~canek/gentoo-systemd-only/dist/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="!sys-apps/baselayout"

src_install() {
	cp -r "${S}"/* "${D}"
}

pkg_postinst() {
	local x

	# We installed some files to /usr/share/systemd-baselayout instead of /etc to stop
	# (1) overwriting the user's settings
	# (2) screwing things up when attempting to merge files
	# (3) accidentally packaging up personal files with quickpkg
	# If they don't exist then we install them
	for x in master.passwd passwd shadow group fstab ; do
		[ -e "${ROOT}etc/${x}" ] && continue
		[ -e "${ROOT}usr/share/baselayout/${x}" ] || continue
		cp -p "${ROOT}usr/share/baselayout/${x}" "${ROOT}"etc
	done

	# Force shadow permissions to not be world-readable #260993
	for x in shadow ; do
		[ -e "${ROOT}etc/${x}" ] && chmod o-rwx "${ROOT}etc/${x}"
	done

	# Take care of the etc-update for the user
	if [ -e "${ROOT}"/etc/._cfg0000_gentoo-release ] ; then
		mv "${ROOT}"/etc/._cfg0000_gentoo-release "${ROOT}"/etc/gentoo-release
	fi

	# whine about users that lack passwords #193541
	if [[ -e ${ROOT}/etc/shadow ]] ; then
		local bad_users=$(sed -n '/^[^:]*::/s|^\([^:]*\)::.*|\1|p' "${ROOT}"/etc/shadow)
		if [[ -n ${bad_users} ]] ; then
			echo
			ewarn "The following users lack passwords!"
			ewarn ${bad_users}
		fi
	fi

	# whine about users with invalid shells #215698
	if [[ -e ${ROOT}/etc/passwd ]] ; then
		local bad_shells=$(awk -F: 'system("test -e " $7) { print $1 " - " $7}' /etc/passwd | sort)
		if [[ -n ${bad_shells} ]] ; then
			echo
			ewarn "The following users have non-existent shells!"
			ewarn "${bad_shells}"
		fi
	fi
	
	ewarn ""
	ewarn "The file /etc/hostname replaces /etc/conf.d/hostname"
	ewarn "from baselayout: please consult hostname(5)."
	ewarn ""
	ewarn "For more information on the different configuration"
	ewarn "files, please visit:"
	ewarn ""
	ewarn "http://0pointer.de/blog/projects/the-new-configuration-files.html"
	ewarn ""
	ewarn "This is an experimental release to replace baselayout"
	ewarn "with the purpose of having an \"only systemd\" Gentoo"
	ewarn "system. It is not guaranteed to work, and it will"
	ewarn "probably eat your system and make it unusable. Use at"
	ewarn "your own risk."
}
