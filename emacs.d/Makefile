EMACS       := emacs
EMACS_BATCH := $(EMACS) --no-init-file --no-site-file --batch
EMACS_LOAD  := $(EMACS_BATCH) --load

INIT_FILE   := init.el

.PHONY: test
test:
	$(EMACS_LOAD) $(INIT_FILE)
