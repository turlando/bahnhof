.PHONY: all
all: /etc/locale.conf /etc/locale.gen

/etc/locale.conf: locale.conf
	install -oroot -groot -m644 $< $@

/etc/locale.gen:
	sed -i '/^#it_IT.UTF-8 UTF-8/s/#//g' $@
	sed -i '/^#en_US.UTF-8 UTF-8/s/#//g' $@
	locale-gen
