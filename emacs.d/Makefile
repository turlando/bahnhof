EMACS        := emacs
EMACS_NOCONF := $(EMACS) --no-init-file --no-site-file
EMACS_BATCH  := $(EMACS_NOCONF) --batch

INIT_FILE   := init.el

.PHONY: test
test:
	$(EMACS_BATCH) --load $(INIT_FILE)

.PHONY: run
run:
	$(EMACS_NOCONF) --load $(INIT_FILE)
