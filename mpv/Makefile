.PHONY: all
all: $(HOME)/.config/mpv/input.conf

$(HOME)/.config/mpv/input.conf: input.conf
	install -D -o$(USER) -gusers -m664 -D $< $@
