_pkgbase=distro-tools
_ver=0.15.6
_branch=master

pkgbase=distro-tools-git
pkgname=('distro-tools-base-git'
	'distro-tools-pkg-git'
	'distro-tools-iso-git'
	'distro-tools-yaml-git')
pkgver=r8.56fa190
pkgrel=1
arch=('x86_64' 'i686')
pkgdesc='Development tools for Garuda Linux'
license=('GPL')
groups=('distro-tools')
url='https://github.com/p30developer/distro-builder'
makedepends=('git')
source=("distro-tools::git+$url.git#branch=$_branch")
sha256sums=('SKIP')

prepare() {
	cd "${srcdir}"/${_pkgbase} || exit
	sed -e "s/^Version=.*/Version=$_ver/" -i Makefile

}

pkgver() {
	cd "${srcdir}"/${_pkgbase} || exit
	printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build() {
	cd "${srcdir}"/${_pkgbase} || exit
	make SYSCONFDIR=/etc PREFIX=/usr
}

package_distro-tools-base-git() {
	pkgdesc='Development tools for PersianOSX Linux (base tools)'
	provides=("distro-tools-base=$_ver")
	depends=('openssh' 'rsync' 'haveged' 'os-prober' 'gnupg' 'pacman-mirrorlist')
	optdepends=('distro-tools-pkg: Garuda Linux package tools'
		'distro-tools-iso: Garuda Linux iso tools'
		'distro-tools-yaml: Garuda Linux yaml tools')
	conflicts=('distro-tools-base')
	backup=('etc/distro-tools/distro-tools.conf')

	cd "${srcdir}"/${_pkgbase} || exit
	make SYSCONFDIR=/etc PREFIX=/usr DESTDIR="${pkgdir}" install_base
}

package_distro-tools-pkg-git() {
	pkgdesc='Development tools for Garuda Linux (packaging tools)'
	provides=("distro-tools-pkg=$_ver")
	depends=('namcap' 'distro-tools-base-git')
	conflicts=('distro-tools-pkg' 'devtools')

	cd "${srcdir}"/${_pkgbase} || exit
	make SYSCONFDIR=/etc PREFIX=/usr DESTDIR="${pkgdir}" install_pkg
}

package_distro-tools-yaml-git() {
	pkgdesc='Development tools for Garuda Linux (yaml tools)'
	provides=("distro-tools-yaml=$_ver")
	conflicts=('distro-tools-yaml')
	depends=('distro-tools-base-git' 'calamares-tools')

	cd "${srcdir}"/${_pkgbase} || exit
	make SYSCONFDIR=/etc PREFIX=/usr DESTDIR="${pkgdir}" install_yaml
}

package_distro-tools-iso-git() {
	pkgdesc='Development tools for Garuda Linux (ISO tools)'
	provides=("distro-tools-iso=$_ver")
	depends=('dosfstools' 'libisoburn' 'squashfs-tools' 'distro-tools-yaml-git'
		'dracut' 'mktorrent' 'grub' 'git' 'zsync' 'rclone')
	conflicts=('distro-tools-iso')
	optdepends=('virtualbox: quickly test isos'
		'snapd: for snapd support')

	cd "${srcdir}"/${_pkgbase} || exit
	make SYSCONFDIR=/etc PREFIX=/usr DESTDIR="${pkgdir}" install_iso
}
