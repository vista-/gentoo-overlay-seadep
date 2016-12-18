# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils

DESCRIPTION="A simple way to find and share indie games online for free."

HOMEPAGE="https://itch.io/"

SRC_URI="https://github.com/itchio/itch/releases/download/v${PV}/itch-${PV}-amd64.tar.xz
	 x86?	( https://github.com/itchio/itch/releases/download/v${PV}/itch-${PV}-386.tar.xz )"

KEYWORDS="~amd64 ~x86"

LICENSE="GPLv3"
SLOT="0"
RESTRICT="mirror"
DEPEND="
	dev-libs/expat
	dev-libs/nss
	gnome-base/gconf
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/libpng
	net-print/cups
	net-libs/gnutls
	sys-libs/zlib
	x11-libs/gtk+
	x11-libs/libnotify
	x11-libs/libxcb
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	"
RDEPEND="${DEPEND}"


src_unpack() {
    	if [ "${A}" != "" ]; then
        	unpack ${A}
    	fi

	# As itch uses different names within their tarball depending on the arch this will set it to the correct name.
	if use amd64; then
		S=${WORKDIR}/itch-${PV}-amd64
	elif use x86; then
		S=${WORKDIR}/itch-${PV}-386
	fi
}

src_install() {

	local destdir="/opt/${PN}"

	insinto $destdir
	doins -r locales resources
	doins \
		blink_image_resources_200_percent.pak \
		content_resources_200_percent.pak \
		ui_resources_200_percent.pak \
		views_resources_200_percent.pak \
		content_shell.pak \
		icudtl.dat \
		natives_blob.bin \
		snapshot_blob.bin \
		libnode.so \
		libffmpeg.so

	exeinto $destdir
	doexe itch

	doins $FILESDIR/ico/itch.png
	dosym $destdir/itch /usr/bin/itch
	make_desktop_entry itch Itch \
		"/opt/itch/itch.png" \
		Network
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
