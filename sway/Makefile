.PHONY: all
all: /home/$(USER)/.config/sway/config     \
     /home/$(USER)/.config/sway/autostart  \
     /home/$(USER)/.config/swaylock/config \
     /home/$(USER)/.config/i3status/config \
     sway-reload

/home/$(USER)/.config/sway/config: sway_config
	install -o$(USER) -gusers -m664 -D $< $@

/home/$(USER)/.config/sway/autostart: sway_autostart
	install -o$(USER) -gusers -m664 -D $< $@

/home/$(USER)/.config/swaylock/config: swaylock_config
	install -o$(USER) -gusers -m664 -D $< $@

/home/$(USER)/.config/i3status/config: i3status_config
	install -o$(USER) -gusers -m664 -D $< $@

.PHONY: sway-reload
sway-reload:
	swaymsg reload
