.PHONY: all
all: /etc/pulse/default.pa

.PHONY: /etc/pulse/default.pa
/etc/pulse/default.pa:
	if grep moduke-switch-on-connect $@; then \
	echo "" >>$@; \
	echo "# Switch the output sound to the newly connected device" >>$@; \
	echo "load-module module-switch-on-connect" >>$@; \
	fi

.PHONY: pulse-backup
pulse-backup:
	cp -p /etc/pulse/default.pa /etc/pulse/default.pa.$(shell date +'%s')
