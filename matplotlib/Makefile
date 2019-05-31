.PHONY: all
all: $(HOME)/.config/matplotlib/matplotlibrc

$(HOME)/.config/matplotlib/matplotlibrc: matplotlibrc
	install -D -o$(USER) -gusers -m664 -D $< $@
