.PHONY: all
all: $(HOME)/.config/sway/config     \
     $(HOME)/.config/sway/autostart  \
     $(HOME)/.config/swaylock/config \
     $(HOME)/.config/i3status/config

$(HOME)/.config/sway/config: sway_config
	install -o$(USER) -gusers -m664 -D $< $@

$(HOME)/.config/sway/autostart: sway_autostart
	install -o$(USER) -gusers -m664 -D $< $@

$(HOME)/.config/swaylock/config: swaylock_config
	install -o$(USER) -gusers -m664 -D $< $@

$(HOME)/.config/i3status/config: i3status_config
	install -o$(USER) -gusers -m664 -D $< $@

.PHONY: reload
sway-reload:
	swaymsg reload
