# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1

DESCRIPTION="Cli and curses mixer for pulseaudio"
HOMEPAGE="https://github.com/GeorgeFilipkin/pulsemixer"
SRC_URI="https://github.com/GeorgeFilipkin/pulsemixer/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0"

RDEPEND="media-sound/pulseaudio"
