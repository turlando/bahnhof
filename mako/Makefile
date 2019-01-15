.PHONY: all
all: $(HOME)/.config/mako/config

$(HOME)/.config/mako/config: mako.conf
	install -D -o$(USER) -gusers -m664 -D $< $@
