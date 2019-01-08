.PHONY: all
all: $(HOME)/.config/twmn/twmn.conf

$(HOME)/.config/twmn/twmn.conf: twmn.conf
	install -o$(USER) -gusers -m664 -D $< $@
