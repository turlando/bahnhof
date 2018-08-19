.PHONY: all
all: /home/$(USER)/.config/systemd/user/emacs.service \
     /home/$(USER)/.local/bin/ec                      \
     enable																						\
     start

/home/$(USER)/.config/systemd/user/emacs.service: emacs.service
	install -o$(USER) -gusers -m664 -D $< $@

.PHONY: enable
enable:
	systemctl --user enable emacs.service

.PHONY: disable
disable:
	systemctl --user enable emacs.service

.PHONY: start
start:
	systemctl --user start emacs.service

.PHONY: stop
stop:
	systemctl --user stop emacs.service

/home/$(USER)/.local/bin/ec: ec.sh
	install -o$(USER) -gusers -m764 $< $@
