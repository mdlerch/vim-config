source ~/.vim/ftplugin/r.vim
source ~/.vim/ftplugin/markdown.vim
source ~/.vim/ftplugin/r_knitr_bindings.vim

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

autocmd InsertEnter *.Rmd call RmdInsertMode()

map  <buffer> <LocalLeader>kh <Plug>RMakeHTML
imap <buffer> <LocalLeader>kh <Esc><Plug>RMakeHTML
map  <buffer> <LocalLeader>kk <Plug>RMakeRmd
imap <buffer> <LocalLeader>kk <Esc><Plug>RMakeRmd
map  <buffer> <LocalLeader>ka <Plug>RMakeAll
imap <buffer> <LocalLeader>ka <Esc><Plug>RMakeAll

