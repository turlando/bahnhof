.PHONY: all
all: $(HOME)/.local/bin/ec           \
     $(HOME)/.local/bin/flac2mp3     \
     $(HOME)/.local/bin/flacstripart \
     $(HOME)/.local/bin/lsws         \
     $(HOME)/.local/bin/mpctl        \
     $(HOME)/.local/bin/winlegal

$(HOME)/.local/bin/ec: ec.sh
	install -o$(USER) -gusers -m764 $< $@

$(HOME)/.local/bin/flac2mp3: flac2mp3.sh
	install -o$(USER) -gusers -m764 $< $@

$(HOME)/.local/bin/flacstripart: flacstripart.sh
	install -o$(USER) -gusers -m764 $< $@

$(HOME)/.local/bin/lsws: lsws.sh
	install -o$(USER) -gusers -m764 -D $< $@

$(HOME)/.local/bin/mpctl: mpctl.sh
	install -o$(USER) -gusers -m764 $< $@

$(HOME)/.local/bin/winlegal: winlegal.sh
	install -o$(USER) -gusers -m764 $< $@
