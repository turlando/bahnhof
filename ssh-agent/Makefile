.PHONY: all
all: /home/$(USER)/.config/systemd/user/ssh-agent.service \
     /home/$(USER)/.zprofile \
     ssh-agent-enable

/home/$(USER)/.config/systemd/user/ssh-agent.service: ssh-agent.service
	install -o$(USER) -gusers -m664 -D $< $@

.PHONY: /home/$(USER)/.zprofile
/home/$(USER)/.zprofile:
	if ! grep SSH_AUTH_SOCK $@; then \
	    echo "" >>$@; \
	    echo "# ssh-agent" >>$@; \
	    echo "eval \$$(systemctl --user show-environment | grep SSH_AUTH_SOCK)" >>$@; \
	    echo "export SSH_AUTH_SOCK" >>$@; \
	fi

.PHONY: ssh-agent-enable
ssh-agent-enable:
	systemctl --user enable ssh-agent.service

.PHONY: ssh-agent-start
ssh-agent-start: ssh-agent-enable
	systemctl --user start ssh-agent.service
