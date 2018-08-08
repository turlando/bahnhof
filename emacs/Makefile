.PHONY: all
all: /home/$(USER)/.config/systemd/user/emacs.service \
     /home/$(USER)/.local/bin/ec                      \
     emacs-enable                                     \
     emacs-start

/home/$(USER)/.config/systemd/user/emacs.service: emacs.service
	install -o$(USER) -gusers -m664 -D $< $@

.PHONY: emacs-enable
emacs-enable:
	systemctl --user enable emacs.service

.PHONY: emacs-disable
emacs-disable:
	systemctl --user enable emacs.service

.PHONY: emacs-start
emacs-start:
	systemctl --user start emacs.service

.PHONY: emacs-stop
emacs-stop:
	systemctl --user stop emacs.service

/home/$(USER)/.local/bin/ec: ec.sh
	install -o$(USER) -gusers -m764 $< $@
