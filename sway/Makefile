.PHONY: all
all:  /home/$(USER)/.config/sway/config /home/$(USER)/.config/sway/autostart \
      /home/$(USER)/.local/bin/lsws \
      sway-reload

/home/$(USER)/.config/sway/config: config 
	install -o$(USER) -gusers -m664 $< $@

/home/$(USER)/.config/sway/autostart: autostart
	install -o$(USER) -gusers -m664 $< $@

/home/$(USER)/.local/bin/lsws: lsws
	install -o$(USER) -gusers -m764 $< $@

.PHONY: sway-reload
sway-reload:
	swaymsg reload
