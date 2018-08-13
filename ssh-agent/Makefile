.PHONY: all
all: /home/$(USER)/.config/systemd/user/ssh-agent.service \
     ssh-agent-enable                                     \
     ssh-agent-stop                                       \
     ssh-agent-start

/home/$(USER)/.config/systemd/user/ssh-agent.service: ssh-agent.service
	install -o$(USER) -gusers -m664 -D $< $@

.PHONY: ssh-agent-enable
ssh-agent-enable:
	systemctl --user enable ssh-agent.service

.PHONY: ssh-agent-disable
ssh-agent-disable:
	systemctl --user disable ssh-agent.service

.PHONY: ssh-agent-start
ssh-agent-start:
	systemctl --user start ssh-agent.service

.PHONY: ssh-agent-stop
ssh-agent-stop:
	systemctl --user stop ssh-agent.service
