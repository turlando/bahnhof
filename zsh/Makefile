.PHONY: all
all:  /home/$(USER)/.zshenv /home/$(USER)/.zshrc

/home/$(USER)/.zshenv: zshenv.zsh
	install -o$(USER) -gusers -m664 $< $@

/home/$(USER)/.zshrc: zshrc.zsh
	install -o$(USER) -gusers -m664 $< $@
