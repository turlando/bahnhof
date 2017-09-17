.PHONY: all
all:  /home/$(USER)/.zprofile /home/$(USER)/.zshrc

/home/$(USER)/.zprofile: zprofile
	install -o$(USER) -gusers -m664 $< $@

/home/$(USER)/.zshrc: zshrc
	install -o$(USER) -gusers -m664 $< $@
