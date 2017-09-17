.PHONY: all
all: /etc/default/tlp tlp-enable 

/etc/default/tlp: tlp
	install -oroot -groot -m644 $< $@

.PHONY: tlp-enable
tlp-enable:
	systemctl enable tlp.service
	systemctl enable tlp-sleep.service
	systemctl mask systemd-rfkill.service
	systemctl mask systemd-rfkill.socket

.PHONY: tlp-start
tlp-start: tlp-enable
	systemctl start tlp.service
	systemctl start tlp-sleep.service

.PHONY: tlp-backup
tlp-backup:
	cp -p /etc/default/tlp /etc/default/tlp.$(shell date +'%s')
