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
    let tline = line('.')

    if nextline =~ '^=\+$'
        exe "normal! jdd"
    elseif nextline =~ '^-\+$'
        exe "normal! jdd"
    elseif thisline =~ '^### .* ###$'
        exe "normal! 04x$3h4x"
    elseif thisline =~ '^#### .* ####$'
        exe "normal! 05x$4h5x"
    endif

    exe "normal! " . tline . "G<CR>"
    if (foldclosed('.') > -1)
        let folded = 1
        let foldline = tline - 1
        exe "normal! zO"
    else
        let folded = 0
    endif

    if a:level == 1
        exe "normal VypVr="
    elseif a:level == 2
        exe "normal VypVr-"
    elseif a:level == 3
        exe "normal! I### A ###"
    elseif a:level == 4
        exe "normal! I#### A ####"
    endif

    if folded == 1
        let curline = line('.')
        exe "normal! " . foldline ."G<CR>"
        exe "normal! za"
        exe "normal! " . curline . "G<CR>"
    endif

    if line('.') == line('$')
        exe "normal! o"
    endif
endfunction


noremap  <buffer> <leader>1 :call ToggleSection(1)<CR>
inoremap <buffer> <leader>1 <C-g>u<ESC>:call ToggleSection(1)<CR>
noremap  <buffer> <leader>2 :call ToggleSection(2)<CR>
inoremap <buffer> <leader>2 <C-g>u<ESC>:call ToggleSection(2)<CR>
noremap  <buffer> <leader>3 :call ToggleSection(3)<CR>
inoremap <buffer> <leader>3 <C-g>u<ESC>:call ToggleSection(3)<CR>
noremap  <buffer> <leader>4 :call ToggleSection(4)<CR>
inoremap <buffer> <leader>4 <C-g>u<ESC>:call ToggleSection(4)<CR>

if expand("%:t") =~ "GHI_"
    setl fo-=t
endif
