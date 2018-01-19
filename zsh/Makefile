.PHONY: all
all:  /home/$(USER)/.zshenv /home/$(USER)/.zshrc

/home/$(USER)/.zshenv: zshenv
	install -o$(USER) -gusers -m664 $< $@

/home/$(USER)/.zshrc: zshrc
	install -o$(USER) -gusers -m664 $< $@
