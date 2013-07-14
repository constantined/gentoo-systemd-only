# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="User land tool for cleaning up old perl installs"
HOMEPAGE="http://www.gentoo.org/proj/en/perl/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	http://dev.gentoo.org/~tove/distfiles/${CATEGORY}/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="app-shells/bash
	|| ( >=sys-apps/coreutils-8.15 app-misc/realpath sys-freebsd/freebsd-bin )
	dev-lang/perl
	sys-libs/elog-functions"

src_install() {
	dosbin perl-cleaner
	doman perl-cleaner.1

	sed -i -e \
	"s:/etc/init.d/functions.sh:/usr/$(get_libdir)/misc/elog-functions.sh:g" \
	"${D}"/usr/sbin/${PN}
}
