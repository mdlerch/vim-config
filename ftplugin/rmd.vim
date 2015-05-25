source ~/.vim/ftplugin/r.vim
source ~/.vim/ftplugin/markdown.vim
source ~/.vim/ftplugin/r_knitr_bindings.vim
runtime ftplugin/markdown_folding.vim

setl spell

iabbrev <buffer> -- <-

function! RmdInsertMode()
    let coderegionstart = search("^[ \t]*```[ ]*{r", "bncW")
    let coderegionend = search("^[ \t]*```$", "bncW")
    if coderegionstart > coderegionend " in code
        setl fo-=t
        iabbrev <buffer> -- <-
        setl commentstring=#\ %s
    else "in prose
        setl fo+=t
        iabbrev <buffer> -- --
        setl commentstring=<!--\ %s\ -->
    endif
endfunction

augroup RMARKDOWN
    autocmd!
    autocmd InsertEnter *.Rmd call RmdInsertMode()
augroup END

map  <buffer> <LocalLeader>kk <Plug>RMakeRmd
map  <buffer> <LocalLeader>kh <Plug>RMakeHTML
map  <buffer> <LocalLeader>ka <Plug>RMakeAll
