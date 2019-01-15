.PHONY: all
all: $(HOME)/.local/bin/flac2mp3     \
     $(HOME)/.local/bin/flacstripart \
     $(HOME)/.local/bin/winlegal

$(HOME)/.local/bin/flac2mp3: flac2mp3.sh
	install -D -o$(USER) -gusers -m764 $< $@

$(HOME)/.local/bin/flacstripart: flacstripart.sh
	install -D -o$(USER) -gusers -m764 $< $@

$(HOME)/.local/bin/winlegal: winlegal.sh
	install -D -o$(USER) -gusers -m764 $< $@
