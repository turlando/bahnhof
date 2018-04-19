.PHONY: all
all:  /home/$(USER)/.gitconfig

/home/$(USER)/.gitconfig: gitconfig
	install -o$(USER) -gusers -m664 $< $@
