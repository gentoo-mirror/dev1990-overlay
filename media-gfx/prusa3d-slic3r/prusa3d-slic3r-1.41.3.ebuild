# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils perl-module cmake-utils

PVE=${PV/_/-}

DESCRIPTION="G-code generator for 3D printers (RepRap, Makerbot, Ultimaker etc.)"
HOMEPAGE="https://github.com/prusa3d/Slic3r"
SRC_URI="https://github.com/prusa3d/Slic3r/archive/version_${PVE}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3 CC-BY-3.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="+gui test"

RDEPEND="!media-gfx/slic3r
	!=dev-lang/perl-5.16*
	>=dev-libs/boost-1.55[threads]
	>=dev-perl/Encode-Locale-1.50.0
	>=dev-perl/Math-PlanePath-53.0.0
	>=dev-perl/Moo-1.3.1
	>=virtual/perl-threads-1.960.0
	dev-cpp/tbb
	dev-perl/Class-XSAccessor
	dev-perl/Devel-CheckLib
	dev-perl/Devel-Size
	dev-perl/IO-stringy
	dev-perl/XML-SAX-ExpatXS
	sci-libs/nlopt
	virtual/perl-Carp
	virtual/perl-Encode
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	virtual/perl-Scalar-List-Utils
	virtual/perl-Test-Simple
	virtual/perl-Thread-Semaphore
	virtual/perl-Time-HiRes
	virtual/perl-Unicode-Normalize
	virtual/perl-XSLoader
	virtual/perl-parent
	gui? (
		>=dev-perl/Wx-0.991.800
		>=media-libs/freeglut-3
		>=virtual/perl-Socket-2.16.0
		dev-perl/Class-Accessor
		dev-perl/Growl-GNTP
		dev-perl/Module-Pluggable
		dev-perl/Net-Bonjour
		dev-perl/Net-DBus
		dev-perl/OpenGL
		dev-perl/Wx-GLCanvas
		dev-perl/libwww-perl
		virtual/perl-Math-Complex
		x11-libs/libXmu
	)
"

DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-CppGuess-0.70.0
	>=dev-perl/ExtUtils-Typemaps-Default-1.50.0
	>=dev-perl/ExtUtils-XSpp-0.170.0
	>=dev-perl/Module-Build-0.380.0
	>=dev-perl/Module-Build-WithXSpp-0.140.0
	>=virtual/perl-ExtUtils-MakeMaker-6.800.0
	>=virtual/perl-ExtUtils-ParseXS-3.220.0
	dev-perl/Devel-CheckLib
	test? (
		virtual/perl-Test-Harness
		virtual/perl-Test-Simple
	)
"

S="${WORKDIR}/Slic3r-version_${PVE}"

src_prepare() {
	pushd "${S}" || die
	sed -i lib/Slic3r.pm -e "s@FindBin::Bin@FindBin::RealBin@g" || die
	eapply_user
	popd || die
}

src_configure() {
	cmake-utils_src_configure
	SLIC3R_NO_AUTO=1 perl-module_src_configure
}

src_test() {
	perl-module_src_test
	prove -Ixs/blib/arch -Ixs/blib/lib/ t/ || die "Tests failed"
}

src_install() {
	MY_ARCH=$(basename $VENDOR_ARCH)
	perl-module_src_install

	insinto "${VENDOR_ARCH}"/auto
	doins -r local-lib/lib/perl5/$MY_ARCH/auto/Slic3r

	insinto "${VENDOR_ARCH}"
	doins -r local-lib/lib/perl5/$MY_ARCH/Slic3r

	insinto "${VENDOR_LIB}"
	doins -r lib/Slic3r.pm lib/Slic3r

	insinto "${VENDOR_LIB}"/Slic3r
	doins -r resources

	exeinto "${VENDOR_LIB}"/Slic3r
	doexe slic3r.pl

	dosym "${VENDOR_LIB}"/Slic3r/slic3r.pl /usr/bin/slic3r.pl

	make_desktop_entry slic3r.pl \
		"Slic3r Prusa Edition"\
		"${VENDOR_LIB}/Slic3r/resources/icons/Slic3r_128px.png" \
		"Graphics;3DGraphics;Engineering;Development"
}