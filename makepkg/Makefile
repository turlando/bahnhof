.PHONY: all
all: /etc/makepkg.conf

.PHONY: /etc/makepkg.conf
/etc/makepkg.conf:
	sed -i '/^PKGEXT=/s/tar\.xz/tar/g' $@
