# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

if [[ "${PV}" == "9999" ]]; then
	inherit git-2
fi

DESCRIPTION="Script used to reinstall Python packages after changing of active Python versions"
HOMEPAGE="http://www.gentoo.org/proj/en/Python/"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
	EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/python-updater.git"
else
	SRC_URI="http://dev.gentoo.org/~floppym/dist/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="$([[ "${PV}" == "9999" ]] && echo "sys-apps/help2man")"
RDEPEND="dev-lang/python
	|| ( >=sys-apps/portage-2.1.6 >=sys-apps/paludis-0.56.0 )
	sys-libs/elog-functions"

src_compile() {
	if [[ "${PV}" == "9999" ]]; then
		emake ${PN}.1 || die "Generation of man page failed"
	fi
}

src_install() {
	dosbin ${PN}
	doman ${PN}.1
	dodoc AUTHORS
	sed -i -e \
		"s:/etc/init.d/functions.sh:/usr/$(get_libdir)/misc/elog-functions.sh:g" \
		"${D}"/usr/sbin/${PN}
}
