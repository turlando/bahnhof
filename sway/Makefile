.PHONY: all
all:  /home/$(USER)/.config/sway/config /home/$(USER)/.config/sway/autostart \
      /home/$(USER)/.config/swaylock/config \
      /home/$(USER)/.config/i3status/config \
      /home/$(USER)/.local/bin/lsws \
      sway-reload

/home/$(USER)/.config/sway/config: config
	install -o$(USER) -gusers -m664 -D $< $@

/home/$(USER)/.config/sway/autostart: autostart
	install -o$(USER) -gusers -m664 -D $< $@

/home/$(USER)/.config/swaylock/config: swaylock_config
	install -o$(USER) -gusers -m664 -D $< $@

/home/$(USER)/.config/i3status/config: i3status.conf
	install -o$(USER) -gusers -m664 -D $< $@

/home/$(USER)/.local/bin/lsws: lsws
	install -o$(USER) -gusers -m764 -D $< $@

.PHONY: sway-reload
sway-reload:
	swaymsg reload
