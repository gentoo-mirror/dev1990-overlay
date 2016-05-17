# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qtsdk

DESCRIPTION="Qt 5 sdk for gcc compiler"
HOMEPAGE="https://github.com/dev-0x7C6/dev1990-overlay"
SRC_URI="http://download.qt.io/development_releases/qt/${QPV%.*}/${QPV}/single/qt-everywhere-opensource-src-${QPV}.tar.xz"

LICENSE="LGPL-3"
SLOT="${QPV}"
KEYWORDS="arm arm64 x86 amd64"

DEPEND=" \
	sys-devel/gcc \
"

RDEPEND="${DEPEND}"