.PHONY: all
all: $(HOME)/.config/sway/config     \
     $(HOME)/.config/sway/autostart  \
     $(HOME)/.config/swaylock/config \
     $(HOME)/.config/i3status/config \
     $(HOME)/.local/bin/lsws         \
     $(HOME)/.local/bin/menu         \
     $(HOME)/.local/bin/scrot

$(HOME)/.config/sway/config: sway.conf
	install -D -o$(USER) -gusers -m664 -D $< $@

$(HOME)/.config/sway/autostart: autostart.conf
	install -D -o$(USER) -gusers -m664 -D $< $@

$(HOME)/.config/swaylock/config: swaylock.conf
	install -D -o$(USER) -gusers -m664 -D $< $@

$(HOME)/.config/i3status/config: i3status.conf
	install -D -o$(USER) -gusers -m664 -D $< $@

$(HOME)/.local/bin/lsws: lsws.sh
	install -D -o$(USER) -gusers -m764 -D $< $@

$(HOME)/.local/bin/menu: menu.sh
	install -D -o$(USER) -gusers -m764 -D $< $@

$(HOME)/.local/bin/scrot: scrot.sh
	install -D -o$(USER) -gusers -m764 -D $< $@

.PHONY: reload
reload:
	swaymsg reload
