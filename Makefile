DESTDIR = .
BOARDS = gateway_dk

TCLSH := $(shell command -v tclsh 2> /dev/null)

VER = $(shell git describe --tags)

all install clean:
ifndef TCLSH
	$(error "tclsh is not available. please  install it.")
	exit 1
endif
	@for board in $(BOARDS); do \
		$(MAKE) -C $$board $@ DESTDIR=$(DESTDIR)/$$board; \
	done

release: $(foreach board,$(BOARDS),rcw-$(board)-$(VER).tar.gz)

$(foreach board,$(BOARDS),rcw-$(board)-$(VER).tar.gz): rcw-%-$(VER).tar.gz:
	git archive --format=tar HEAD --prefix rcw- $* | gzip -9 > $@

.PHONY: all install clean release $(foreach board,$(BOARDS),rcw-$(board)-$(VER).tar.gz)
