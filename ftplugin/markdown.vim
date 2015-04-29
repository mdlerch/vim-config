source ~/.vim/ftplugin/document_preview_bindings.vim

setl expandtab
setl tabstop=4
setl shiftwidth=4
if !exists("b:writing_on") || b:writing_on == 0
    set tw=79
endif

setl comments=s:<!--
setl comments+=m:\ \ \ \ 
setl comments+=e:-->

noremap  <buffer> <leader>1       <ESC>VypVr=<CR>
inoremap <buffer> <leader>1 <C-g>u<ESC>VypVr=o<C-g>u
noremap  <buffer> <leader>2       <ESC>VypVr-<CR>
inoremap <buffer> <leader>2 <C-g>u<ESC>VypVr-o<C-g>u
noremap  <buffer> <leader>3       <ESC>I### <ESC>A ###<ESC>
inoremap <buffer> <leader>3 <C-g>u<ESC>I### <ESC>A ###<ESC>o<C-g>u
noremap  <buffer> <leader>4       <ESC>I#### <ESC>A ####<ESC>
inoremap <buffer> <leader>4 <C-g>u<ESC>I#### <ESC>A ####<ESC>o<C-g>u

if expand("%:t") =~ "GHI_"
    setl fo-=t
endif

