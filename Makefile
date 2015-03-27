VIMDIR = ~/vim-config
LINK = ln -f -s

define INFECT
if ! [ -e $2 ]; then $(LINK) $(VIMDIR)/$(1) $(2) ; else echo "$2 already exists"; fi
endef

all: nvim_

vim: vim_ bundle_
nvim: nvim_ bundle_

vim_:
	if ! [ -e ~/.vim ] ; then $(LINK) $(VIMDIR) ~/.vim ; fi

bundle_:
	if ! [ -e ~/vim-bundle ] ; then mkdir ~/vim-bundle; fi
	${LINK} ~/vim-bundle ${VIMDIR}

nvim_:
	if ! [ -e ~/.nvim ] ; then $(LINK) $(VIMDIR) ~/.nvim ; fi
