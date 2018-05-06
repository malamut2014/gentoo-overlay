# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 autotools

DESCRIPTION="An improved i3lock"
HOMEPAGE="https://github.com/cac03/i3lock"
EGIT_REPO_URI="https://github.com/cac03/i3lock.git"
LICENSE="BSD"
SRC_URI=""

SLOT="0"

RDEPEND="x11-libs/libxcb[xkb]
		x11-libs/xcb-util
		x11-libs/cairo[xcb]
		x11-libs/libxkbcommon[X]
		!x11-misc/i3lock"

DEPEND="${RDEPEND}"

