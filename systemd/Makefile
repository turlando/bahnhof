.PHONY: all
all: /etc/systemd/logind.conf

/etc/systemd/logind.conf:
	sed -i '/^#HandleLidSwitch=/s/#//g' $@
	sed -i '/^HandleLidSwitch=/s/suspend/lock/g' $@
