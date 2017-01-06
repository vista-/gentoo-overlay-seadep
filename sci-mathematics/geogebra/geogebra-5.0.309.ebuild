# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils git-r3 gnome2-utils xdg
DESCRIPTION="Mathematics software for geometry"
HOMEPAGE="https://www.geogebra.org"
SRC_URI=""
EGIT_REPO_URI="https://github.com/geogebra/geogebra.git"
EGIT_COMMIT="848860bb0e6bc5b786a7a04d1cb282dedf42c65c"
KEYWORDS="~amd64 ~x86"
LICENSE="CC-BY-ND-3.0 GPL-3"
SLOT="0"
RESTRICT="mirror"
IUSE=""
DEPEND="dev-java/oracle-jdk-bin[javafx]
	>=dev-java/gradle-3.0"
# Requires oracle-jdk-bin because there is no openjfx ebuild as of now
RDEPEND="|| (
		virtual/jre:1.8
		virtual/jdk:1.8
	)"

src_compile() {
	gradle :desktop:installDist
}

src_install() {
	local destdir="/opt/${PN}"
	insinto $destdir
	doins -r desktop/build/install/desktop/lib/
	exeinto $destdir/bin
	doexe desktop/build/install/desktop/bin/desktop
	dosym $destdir/bin/desktop /usr/bin/geogebra
	make_desktop_entry geogebra Geogebra "geogebra" Science
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}