.PHONY: all
all: $(HOME)/.ipython/profile_default/startup/00-autoreload.py

$(HOME)/.ipython/profile_default/startup/00-autoreload.py: startup-autoreload.py
	install -D -o$(USER) -gusers -m664 -D $< $@
