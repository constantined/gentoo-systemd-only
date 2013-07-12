# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

DESCRIPTION="Utility to change the binutils version being used"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="userland_GNU? ( !<sys-apps/findutils-4.2 )"

src_install() {
	newbin "${FILESDIR}"/${PN}-${PV} ${PN} || die
	sed -e \
	"s:/etc/init.d/functions.sh:/usr/$(get_libdir)/misc/elog-functions.sh:g" \
	-i ${D}/usr/bin/${PN}
	doman "${FILESDIR}"/${PN}.8
}
