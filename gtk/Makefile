.PHONY: all
all: $(HOME)/.gtkrc-2.0                   \
     $(HOME)/.config/gtk-3.0/settings.ini \
     gsettings

$(HOME)/.gtkrc-2.0: gtk2.ini
	install -o$(USER) -gusers -m664 $< $@

$(HOME)/.config/gtk-3.0/settings.ini: gtk3.ini
	install -D -o$(USER) -gusers -m664 $< $@

.PHONY: gsettings
gsettings:
	gsettings set org.gnome.desktop.interface gtk-theme "Arc-Dark"
	gsettings set org.gnome.desktop.interface icon-theme "Arc"
	gsettings set org.gnome.desktop.interface cursor-theme "Neutral"
