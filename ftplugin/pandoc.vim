source ~/.vim/ftplugin/markdown.vim

" If .md then use pandoc bindings.  If .rmd use Nvim-R Rmarkdown bindings
if &ft !~? "rmd"
    source ~/.vim/ftplugin/document_pandoc_bindings.vim
endif
