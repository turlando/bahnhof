.PHONY: all
all: $(HOME)/.config/systemd/user/emacs.service            \
     $(HOME)/.local/bin/ec                                 \
     $(HOME)/.local/share/applications/emacsclient.desktop

$(HOME)/.config/systemd/user/emacs.service: emacs.service
	install -D -o$(USER) -gusers -m664 -D $< $@

$(HOME)/.local/bin/ec: ec.sh
	install -D -o$(USER) -gusers -m764 $< $@

$(HOME)/.local/share/applications/emacsclient.desktop: emacsclient.desktop
	install -D -o$(USER) -gusers -m764 $< $@

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
