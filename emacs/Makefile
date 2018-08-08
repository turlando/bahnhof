all: /home/$(USER)/.config/systemd/user/emacs.service

/home/$(USER)/.config/systemd/user/emacs.service: emacs.service
	install -o$(USER) -gusers -m664 -D $< $@
