.PHONY: all
all: /home/$(USER)/.config/twmn/twmn.conf

/home/$(USER)/.config/twmn/twmn.conf: twmn.conf
	install -o$(USER) -gusers -m664 -D $< $@
