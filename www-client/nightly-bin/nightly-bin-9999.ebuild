# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Firefox Nightly Web Browser"
HOMEPAGE="https://wiki.mozilla.org/Nightly"
SRC_URI="
	amd64? ( https://download-installer.cdn.mozilla.net/pub/firefox/nightly/latest-mozilla-central/firefox-57.0a1.en-US.linux-x86_64.tar.bz2 -> firefox-nightly_x86_64-9999.tar.bz2 )"
MOZ_PN="nightly"

LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+ffmpeg +pulseaudio selinux startup-notification"

DEPEND="app-arch/unzip"
RDEPEND="dev-libs/atk
	>=sys-apps/dbus-0.60
	>=dev-libs/dbus-glib-0.72
	>=dev-libs/glib-2.26:2
	media-libs/fontconfig
	>=media-libs/freetype-2.4.10
	>=x11-libs/cairo-1.10[X]
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-2.18:2
	>=x11-libs/gtk+-3.4.0:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXt
	>=x11-libs/pango-1.22.0
	virtual/freedesktop-icon-theme
	pulseaudio? ( !<media-sound/apulse-0.1.9
		|| ( media-sound/pulseaudio media-sound/apulse ) )
	ffmpeg? ( media-video/ffmpeg )
	selinux? ( sec-policy/selinux-mozilla )
"
src_unpack() {
	unpack ${A}
	mv firefox nightly-bin-9999
}

src_install() {
	declare MOZILLA_FIVE_HOME=/opt/${MOZ_PN}

	local size sizes name
	name="Firefox Nightly"
	
	# Install firefox in /opt
	dodir ${MOZILLA_FIVE_HOME%/*}
	mv "${S}" "${ED}"${MOZILLA_FIVE_HOME} || die

	insinto ${MOZILLA_FIVE_HOME}/defaults/pref/

	# Create /usr/bin/firefox-bin
	dodir /usr/bin/
	local apulselib=$(usex pulseaudio "/usr/$(get_libdir)/apulse:" "")
	cat <<-EOF >"${ED}"usr/bin/${PN}
	#!/bin/sh
	unset LD_PRELOAD
	LD_LIBRARY_PATH="${apulselib}/opt/firefox/" \\
	GTK_PATH=/usr/lib/gtk-3.0/ \\
	exec /opt/${MOZ_PN}/firefox-bin "\$@"
	EOF
	fperms 0755 /usr/bin/${PN}

	# revdep-rebuild entry
	insinto /etc/revdep-rebuild
	echo "SEARCH_DIRS_MASK=${MOZILLA_FIVE_HOME}" >> ${T}/10${PN}
	doins "${T}"/10${PN} || die

	# Plugins dir, still used for flash
	share_plugins_dir
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	if ! has_version 'gnome-base/gconf' || ! has_version 'gnome-base/orbit' \
		|| ! has_version 'net-misc/curl'; then
		einfo
		einfo "For using the crashreporter, you need gnome-base/gconf,"
		einfo "gnome-base/orbit and net-misc/curl emerged."
		einfo
	fi
	use ffmpeg || ewarn "USE=-ffmpeg : HTML5 video will not render without media-video/ffmpeg installed"
	use pulseaudio || ewarn "USE=-pulseaudio : audio will not play without pulseaudio installed"

}

pkg_postrm() {
	gnome2_icon_cache_update
}

