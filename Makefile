VIMDIR = $(CURDIR)
LINK = ln -s

all: nvim_

.PHONY: status
status:
	@echo "=== Vim config symlink status ==="
	@ls -la ~/.config 2>/dev/null | grep "$(CURDIR)" || true

.PHONY: nvim_
nvim_:
	@if [ -L ~/.config/nvim ] && [ "$$(readlink ~/.config/nvim)" = "$(VIMDIR)" ]; then \
	    echo "  ok: ~/.config/nvim"; \
	elif [ -L ~/.config/nvim ]; then \
	    echo "  WARNING: ~/.config/nvim is a symlink pointing elsewhere: $$(readlink ~/.config/nvim)"; \
	elif [ -e ~/.config/nvim ]; then \
	    echo "  WARNING: ~/.config/nvim is a real directory — skipping. Remove manually to link."; \
	else \
	    $(LINK) $(VIMDIR) ~/.config/nvim && echo "  linked: ~/.config/nvim"; \
	fi
