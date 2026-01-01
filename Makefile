Version=0.1.0

PREFIX = /usr/local
SYSCONFDIR = /etc

SYSCONF = \
	data/distro-tools.conf \
	data/branding.desc.d

BIN_BASE = \
	bin/mkchroot \
	bin/basestrap \
	bin/distro-chroot \
	bin/fstabgen \
	bin/signfile \
	bin/chroot-run

LIBS_BASE = \
	lib/util.sh \
	lib/util-mount.sh \
	lib/util-msg.sh \
	lib/util-fstab.sh

SHARED_BASE = \
	data/pacman-default.conf \
	data/pacman-multilib.conf \
	data/pacman-mirrors.conf

LIST_PKG = \
	$(wildcard data/pkg.list.d/*.list)

ARCH_CONF = \
	$(wildcard data/make.conf.d/*.conf)

BIN_PKG = \
	bin/checkpkg \
	bin/lddd \
	bin/finddeps \
	bin/find-libdeps \
	bin/signpkgs \
	bin/mkchrootpkg \
	bin/buildpkg \
	bin/buildtree

LIBS_PKG = \
	$(wildcard lib/util-pkg*.sh)

SHARED_PKG = \
	data/makepkg.conf

LIST_ISO = \
	$(wildcard data/iso.list.d/*.list)

BIN_ISO = \
	bin/buildiso \
	bin/deployiso \
	bin/buildall \
    bin/checksumiso \
	bin/signiso

LIBS_ISO = \
	$(wildcard lib/util-iso*.sh) \
	lib/util-publish.sh

SHARED_ISO = \
	data/pacman-drivers.conf \
	data/mkinitcpio.conf \
	data/profile.conf.example \
	data/dracut/miso.sh \
	data/dracut/parse-miso.sh \
	data/dracut/miso-generator.sh \
	data/dracut/module-setup.sh

CPIOHOOKS = \
	$(wildcard initcpio/hooks/*)

CPIOINST = \
	$(wildcard initcpio/install/*)

CPIO = \
	initcpio/script/miso_shutdown

BIN_YAML = \
	bin/check-yaml

LIBS_YAML = \
	lib/util-yaml.sh

SHARED_YAML = \
	data/linux.preset

all: $(BIN_BASE) $(BIN_PKG) $(BIN_ISO) $(BIN_YAML)

edit = sed -e "s|@datadir[@]|$(DESTDIR)$(PREFIX)/share/distro-tools|g" \
	-e "s|@sysconfdir[@]|$(DESTDIR)$(SYSCONFDIR)/distro-tools|g" \
	-e "s|@libdir[@]|$(DESTDIR)$(PREFIX)/lib/distro-tools|g" \
	-e "s|@version@|${Version}|"

%: %.in Makefile
	@echo "GEN $@"
	@$(RM) "$@"
	@m4 -P $@.in | $(edit) >$@
	@chmod a-w "$@"
	@chmod +x "$@"


clean:
	rm -f $(BIN_BASE) ${BIN_PKG} ${BIN_ISO}

install_base:
	install -dm0755 $(DESTDIR)$(SYSCONFDIR)/distro-tools
	install -m0644 ${SYSCONF} $(DESTDIR)$(SYSCONFDIR)/distro-tools

	install -dm0755 $(DESTDIR)$(PREFIX)/bin
	install -m0755 ${BIN_BASE} $(DESTDIR)$(PREFIX)/bin

	install -dm0755 $(DESTDIR)$(PREFIX)/lib/distro-tools
	install -m0644 ${LIBS_BASE} $(DESTDIR)$(PREFIX)/lib/distro-tools

	install -dm0755 $(DESTDIR)$(PREFIX)/share/distro-tools
	install -m0644 ${SHARED_BASE} $(DESTDIR)$(PREFIX)/share/distro-tools

	install -dm0755 $(DESTDIR)$(PREFIX)/share/applications
	install -m0644 ${APP_BASE} $(DESTDIR)$(PREFIX)/share/applications

install_pkg:
	install -dm0755 $(DESTDIR)$(SYSCONFDIR)/distro-tools/pkg.list.d
	install -m0644 ${LIST_PKG} $(DESTDIR)$(SYSCONFDIR)/distro-tools/pkg.list.d

	install -dm0755 $(DESTDIR)$(SYSCONFDIR)/distro-tools/make.conf.d
	install -m0644 ${ARCH_CONF} $(DESTDIR)$(SYSCONFDIR)/distro-tools/make.conf.d

	install -dm0755 $(DESTDIR)$(PREFIX)/bin
	install -m0755 ${BIN_PKG} $(DESTDIR)$(PREFIX)/bin

	ln -sf find-libdeps $(DESTDIR)$(PREFIX)/bin/find-libprovides

	install -dm0755 $(DESTDIR)$(PREFIX)/lib/distro-tools
	install -m0644 ${LIBS_PKG} $(DESTDIR)$(PREFIX)/lib/distro-tools

	install -dm0755 $(DESTDIR)$(PREFIX)/share/distro-tools
	install -m0644 ${SHARED_PKG} $(DESTDIR)$(PREFIX)/share/distro-tools

install_iso:
	install -dm0755 $(DESTDIR)$(SYSCONFDIR)/distro-tools/iso.list.d
	install -m0644 ${LIST_ISO} $(DESTDIR)$(SYSCONFDIR)/distro-tools/iso.list.d

	install -dm0755 $(DESTDIR)$(PREFIX)/bin
	install -m0755 ${BIN_ISO} $(DESTDIR)$(PREFIX)/bin

	install -dm0755 $(DESTDIR)$(PREFIX)/lib/distro-tools
	install -m0644 ${LIBS_ISO} $(DESTDIR)$(PREFIX)/lib/distro-tools

	install -dm0755 $(DESTDIR)$(SYSCONFDIR)/initcpio/hooks
	install -m0755 ${CPIOHOOKS} $(DESTDIR)$(SYSCONFDIR)/initcpio/hooks

	install -dm0755 $(DESTDIR)$(SYSCONFDIR)/initcpio/install
	install -m0755 ${CPIOINST} $(DESTDIR)$(SYSCONFDIR)/initcpio/install

	install -m0755 ${CPIO} $(DESTDIR)$(SYSCONFDIR)/initcpio


	install -dm0755 $(DESTDIR)$(PREFIX)/share/distro-tools
	install -m0644 ${SHARED_ISO} $(DESTDIR)$(PREFIX)/share/distro-tools


install_yaml:
	install -dm0755 $(DESTDIR)$(PREFIX)/bin
	install -m0755 ${BIN_YAML} $(DESTDIR)$(PREFIX)/bin

	install -dm0755 $(DESTDIR)$(PREFIX)/lib/distro-tools
	install -m0644 ${LIBS_YAML} $(DESTDIR)$(PREFIX)/lib/distro-tools

	install -dm0755 $(DESTDIR)$(PREFIX)/share/distro-tools
	install -m0644 ${SHARED_YAML} $(DESTDIR)$(PREFIX)/share/distro-tools


uninstall_base:
	for f in ${SYSCONF}; do rm -f $(DESTDIR)$(SYSCONFDIR)/distro-tools/$$f; done
	for f in ${BIN_BASE}; do rm -f $(DESTDIR)$(PREFIX)/bin/$$f; done
	for f in ${SHARED_BASE}; do rm -f $(DESTDIR)$(PREFIX)/share/distro-tools/$$f; done
	for f in ${LIBS_BASE}; do rm -f $(DESTDIR)$(PREFIX)/lib/distro-tools/$$f; done

uninstall_pkg:
	for f in ${LIST_PKG}; do rm -f $(DESTDIR)$(SYSCONFDIR)/distro-tools/pkg.list.d/$$f; done
	for f in ${ARCH_CONF}; do rm -f $(DESTDIR)$(SYSCONFDIR)/distro-tools/make.conf.d/$$f; done
	for f in ${BIN_PKG}; do rm -f $(DESTDIR)$(PREFIX)/bin/$$f; done
	rm -f $(DESTDIR)$(PREFIX)/bin/find-libprovides
	for f in ${SHARED_PKG}; do rm -f $(DESTDIR)$(PREFIX)/share/distro-tools/$$f; done
	for f in ${LIBS_PKG}; do rm -f $(DESTDIR)$(PREFIX)/lib/distro-tools/$$f; done

uninstall_iso:
	for f in ${LIST_ISO}; do rm -f $(DESTDIR)$(SYSCONFDIR)/distro-tools/iso.list.d/$$f; done
	for f in ${BIN_ISO}; do rm -f $(DESTDIR)$(PREFIX)/bin/$$f; done
	for f in ${SHARED_ISO}; do rm -f $(DESTDIR)$(PREFIX)/share/distro-tools/$$f; done

	for f in ${LIBS_ISO}; do rm -f $(DESTDIR)$(PREFIX)/lib/distro-tools/$$f; done
	for f in ${CPIOHOOKS}; do rm -f $(DESTDIR)$(SYSCONFDIR)/initcpio/hooks/$$f; done
	for f in ${CPIOINST}; do rm -f $(DESTDIR)$(SYSCONFDIR)/initcpio/install/$$f; done
	for f in ${CPIO}; do rm -f $(DESTDIR)$(SYSCONFDIR)/initcpio/$$f; done

uninstall_yaml:
	for f in ${BIN_YAML}; do rm -f $(DESTDIR)$(PREFIX)/bin/$$f; done
	for f in ${LIBS_YAML}; do rm -f $(DESTDIR)$(PREFIX)/lib/distro-tools/$$f; done
	for f in ${SHARED_YAML}; do rm -f $(DESTDIR)$(PREFIX)/share/distro-tools/$$f; done

install: install_base install_pkg install_iso install_yaml

uninstall: uninstall_base uninstall_pkg uninstall_iso uninstall_yaml

dist:
	git archive --format=tar --prefix=distro-tools-$(Version)/ $(Version) | gzip -9 > distro-tools-$(Version).tar.gz
	gpg --detach-sign --use-agent distro-tools-$(Version).tar.gz

.PHONY: all clean install uninstall dist
