.PHONY: all
all: /home/$(USER)/.local/bin/ec           \
     /home/$(USER)/.local/bin/flac2mp3     \
     /home/$(USER)/.local/bin/flacstripart

/home/$(USER)/.local/bin/ec: ec.sh
	install -o$(USER) -gusers -m764 $< $@

/home/$(USER)/.local/bin/flac2mp3: flac2mp3.sh
	install -o$(USER) -gusers -m764 $< $@

/home/$(USER)/.local/bin/flacstripart: flacstripart.sh
	install -o$(USER) -gusers -m764 $< $@
