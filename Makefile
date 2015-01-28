VIMDIR = ~/vim-config
LINK = ln -f -s







vim: vim_ bundle_
nvim: nvim_ nvimrc_ nbundle_

vim_:
	${LINK} ${VIMDIR} ~/.vim

bundle_: vim_
	if ! [ -e ~/vim-bundle ] ; then mkdir ~/vim-bundle; fi
	${LINK} ~/vim-bundle ${VIMDIR}

nvim_:
	${LINK} ${VIMDIR} ~/.nvim

nvimrc_: vimrc
	${LINK} ${VIMDIR}/vimrc ~/.nvimrc

nbundle_: nvim_
	if ! [ -e ~/vim-bundle ] ; then mkdir ~/vim-bundle; fi
	${LINK} ~/vim-bundle ${VIMDIR}







