.PHONY: all
all:  /home/$(USER)/.screenlayout/sway-work.sh \
      /home/$(USER)/.screenlayout/x11-work.sh

/home/$(USER)/.screenlayout/sway-work.sh: sway-work.sh
	install -o$(USER) -gusers -m764 -D $< $@

/home/$(USER)/.screenlayout/x11-work.sh: x11-work.sh
	install -o$(USER) -gusers -m764 -D $< $@
