.PHONY: all
all: $(HOME)/.gitconfig

$(HOME)/.gitconfig: gitconfig
	install -o$(USER) -gusers -m664 $< $@
