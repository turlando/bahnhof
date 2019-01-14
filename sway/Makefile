.PHONY: all
all: $(HOME)/.config/sway/config     \
     $(HOME)/.config/sway/autostart  \
     $(HOME)/.config/swaylock/config \
     $(HOME)/.config/i3status/config

$(HOME)/.config/sway/config: sway.conf
	install -D -o$(USER) -gusers -m664 -D $< $@

$(HOME)/.config/sway/autostart: sway_autostart
	install -D -o$(USER) -gusers -m664 -D $< $@

$(HOME)/.config/swaylock/config: swaylock.conf
	install -D -o$(USER) -gusers -m664 -D $< $@

$(HOME)/.config/i3status/config: i3status.conf
	install -D -o$(USER) -gusers -m664 -D $< $@

.PHONY: reload
reload:
	swaymsg reload
