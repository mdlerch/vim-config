runtime ftplugin/document_preview_bindings.vim
runtime ftplugin/markdown_folding.vim

" If .md then use pandoc bindings.  If .rmd use Nvim-R Rmarkdown bindings
if &ft !~? "rmd"
    source ~/.vim/ftplugin/document_pandoc_bindings.vim
endif

setl expandtab
setl tabstop=4
setl shiftwidth=4

if !exists("b:writing_on") || b:writing_on == 0
    set tw=79
endif

setl comments=s:<!--
setl comments+=m:\ \ \ \ 
setl comments+=e:-->

function! ToggleSection(level)
    let thisline = getline('.')
    let nextline = getline(line('.') + 1)
    if a:level == 1
        if nextline =~ '^=\+$'
            exe "normal! jdd"
        else
            exe "normal VypVr="
        endif
    elseif a:level == 2
        if nextline =~ '^-\+$'
            exe "normal! jdd"
        else
            exe "normal VypVr-"
        endif
    elseif a:level == 3
        if thisline =~ '^### .* ###$'
            exe "normal! 04x$3h4x"
        else
            exe "normal! I### A ###"
        endif
    elseif a:level == 4
        if thisline =~ '^#### .* ####$'
            exe "normal! 04x$3h4x"
        else
            exe "normal! I#### A ####"
        endif
    endif
endfunction


noremap  <buffer> <leader>1 :call ToggleSection(1)<CR>
inoremap <buffer> <leader>1 <C-g>u<ESC>:call ToggleSection(1)<C-g>u
noremap  <buffer> <leader>2 :call ToggleSection(2)<CR>
inoremap <buffer> <leader>2 <C-g>u<ESC>:call ToggleSection(2)<C-g>u
noremap  <buffer> <leader>3 :call ToggleSection(3)<CR>
inoremap <buffer> <leader>3 <C-g>u<ESC>:call ToggleSection(3)<ESC>A ###<ESC>o<C-g>u
noremap  <buffer> <leader>4 :call ToggleSection(4)<CR>
inoremap <buffer> <leader>4 <C-g>u<ESC>:call ToggleSection(4)<ESC>A ####<ESC>o<C-g>u

if expand("%:t") =~ "GHI_"
    setl fo-=t
endif
