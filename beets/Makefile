.PHONY: all
all: /home/$(USER)/.config/beets/config.yaml

/home/$(USER)/.config/beets/config.yaml: config.yaml
	install -o$(USER) -gusers -m664 $< $@
