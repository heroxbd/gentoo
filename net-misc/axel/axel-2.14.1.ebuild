# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Light Unix download accelerator"
HOMEPAGE="https://github.com/axel-download-accelerator/axel"
SRC_URI="https://github.com/axel-download-accelerator/axel/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc64-solaris"
IUSE="debug libressl nls ssl"

CDEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"
DEPEND="${CDEPEND}
	nls? ( sys-devel/gettext )"
RDEPEND="${CDEPEND}
	nls? ( virtual/libintl virtual/libiconv )"

DOCS=( doc/. )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with ssl)
}

pkg_postinst() {
	einfo 'To use axel with portage, create a script in'
	einfo '/usr/local/bin/fetchwrapper.sh with the following content:'
	einfo
	einfo ' #!/bin/bash'
	einfo ' set -e'
	einfo ' /usr/bin/axel -o "$1.axel" "$2"'
	einfo ' mv "$1.axel" "$1"'
	einfo
	einfo 'and then add the following to your make.conf:'
	einfo ' FETCHCOMMAND='\''/usr/local/bin/fetchwrapper.sh "\${DISTDIR}/\${FILE}" "\${URI}"'\'
	einfo ' RESUMECOMMAND="${FETCHCOMMAND}"'
}
