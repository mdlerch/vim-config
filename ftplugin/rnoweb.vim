source ~/.vim/ftplugin/r.vim
source ~/.vim/ftplugin/document_preview_bindings.vim
source ~/.vim/ftplugin/knitr_bindings.vim

setl spell

function! RnwInsertMode()
    let coderegionstart = search("^[ \t]*<<.*>>=", "bncW")
    let coderegionend = search("^[ \t]*@$", "bncW")
    if coderegionstart > coderegionend " in code
        setl fo-=t
        setl commentstring=#\ %s
    else
        setl fo+=t " in prose
        setl commentstring=\%\ %s
    endif
endfunction

augroup RNOWEB
    autocmd!
    autocmd InsertEnter *.Rnw call RnwInsertMode()
augroup END
