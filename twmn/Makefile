.PHONY: all
all: $(HOME)/.config/twmn/twmn.conf

$(HOME)/.config/twmn/twmn.conf: twmn.conf
	install -D -o$(USER) -gusers -m664 -D $< $@
