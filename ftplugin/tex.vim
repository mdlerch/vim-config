if (&ft == "rnoweb")
    finish
endif

source ~/.vim/ftplugin/document_preview_bindings.vim

noremap <buffer><leader>kd <ESC>:w<CR><ESC>:!texi2pdf % <CR>
inoremap <buffer><leader>kd <ESC>:w<CR><ESC>:!texi2pdf % <CR>
noremap <buffer><leader>kk <ESC>:w<CR><ESC>:!texi2pdf % <CR>
inoremap <buffer><leader>kk <ESC>:w<CR><ESC>:!texi2pdf % <CR>
noremap <buffer><leader>kv <ESC>:w<CR><ESC>:!texi2dvi % <CR>
inoremap <buffer><leader>kv <ESC>:w<CR><ESC>:!texi2dvi % <CR>
noremap <buffer><leader>kb <ESC>:w<CR><ESC>:!bibtex %:r <CR>
inoremap <buffer><leader>kb <ESC>:w<CR><ESC>:!bibtex %:r <CR>
noremap <buffer><leader>kc <ESC>:w<CR><ESC>:!latex %; dvipdf %:r.dvi <CR>
inoremap <buffer><leader>kc <ESC>:w<CR><ESC>:!latex %; dvipdf %:r.dvi <CR>

