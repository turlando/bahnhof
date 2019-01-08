.PHONY: all
all:  $(HOME)/.zshenv $(HOME)/.zshrc

$(HOME)/.zshenv: zshenv.zsh
	install -o$(USER) -gusers -m664 $< $@

$(HOME)/.zshrc: zshrc.zsh
	install -o$(USER) -gusers -m664 $< $@
