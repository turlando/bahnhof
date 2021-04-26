PREFIX       ?= $(HOME)/.emacs.d

EMACS        := emacs
EMACS_NOCONF := $(EMACS) --no-init-file --no-site-file
EMACS_BATCH  := $(EMACS_NOCONF) --batch

INIT_FILE    := init.el
LISP_FILES   := $(wildcard *.el lisp/*.el)

.PHONY: test
test:
	$(EMACS_BATCH) --load $(INIT_FILE)

.PHONY: run
run:
	$(EMACS_NOCONF) --load $(INIT_FILE)

.PHONY: install
install: $(addprefix $(PREFIX)/, $(LISP_FILES))

$(PREFIX)/%.el: %.el
	install -D -o $(USER) -gusers -m644 $< $@
