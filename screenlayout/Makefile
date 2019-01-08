.PHONY: all
all:  $(HOME)/.screenlayout/sway-single.sh \
      $(HOME)/.screenlayout/sway-work.sh   \
      $(HOME)/.screenlayout/x11-single.sh  \
      $(HOME)/.screenlayout/x11-work.sh

$(HOME)/.screenlayout/sway-single.sh: sway-single.sh
	install -o$(USER) -gusers -m764 -D $< $@

$(HOME)/.screenlayout/sway-work.sh: sway-work.sh
	install -o$(USER) -gusers -m764 -D $< $@

$(HOME)/.screenlayout/x11-single.sh: x11-single.sh
	install -o$(USER) -gusers -m764 -D $< $@

$(HOME)/.screenlayout/x11-work.sh: x11-work.sh
	install -o$(USER) -gusers -m764 -D $< $@
