.PHONY: all
all: $(HOME)/.config/systemd/user/ssh-agent.service

$(HOME)/.config/systemd/user/ssh-agent.service: ssh-agent.service
	install -o$(USER) -gusers -m664 -D $< $@

.PHONY: enable
enable:
	systemctl --user enable ssh-agent.service

.PHONY: disable
disable:
	systemctl --user disable ssh-agent.service

.PHONY: start
start:
	systemctl --user start ssh-agent.service

.PHONY: stop
stop:
	systemctl --user stop ssh-agent.service
