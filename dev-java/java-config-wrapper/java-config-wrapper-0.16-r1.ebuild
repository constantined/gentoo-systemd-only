# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

DESCRIPTION="Wrapper for java-config"
HOMEPAGE="http://www.gentoo.org/proj/en/java"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="!<dev-java/java-config-1.3"
RDEPEND="app-portage/portage-utils
	sys-libs/elog-functions"

src_install() {
	dobin src/shell/* || die
	dodoc AUTHORS || die
	
	sed -i -e \
	"s:/etc/init.d/functions.sh:/usr/$(get_libdir)/misc/elog-functions.sh:g" \
	"${D}/usr/bin/java-1.5-fixer"

	sed -i -e \
	"s:/etc/init.d/functions.sh:/usr/$(get_libdir)/misc/elog-functions.sh:g" \
	"${D}/usr/bin/java-check-environment"
}
