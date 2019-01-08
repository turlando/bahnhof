.PHONY: all
all: $(HOME)/.local/share/backgrounds/dj-red-alert-mike-slammer_1600x900.jpg\
     $(HOME)/.local/share/backgrounds/default.jpg

$(HOME)/.local/share/backgrounds:
	mkdir -p $@

$(HOME)/.local/share/backgrounds/dj-red-alert-mike-slammer_1600x900.jpg:\
$(HOME)/.local/share/backgrounds
	curl -sS -L -o "$@" "https://i.imgur.com/jaQwSiT.jpg"

$(HOME)/.local/share/backgrounds/default.jpg:\
$(HOME)/.local/share/backgrounds/dj-red-alert-mike-slammer_1600x900.jpg
	ln -s $< $@
