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

augroup RMARKDOWN
    autocmd!
    autocmd InsertEnter *.Rmd call RmdInsertMode()
augroup END

map  <buffer> <LocalLeader>kh <Plug>RMakeHTML
imap <buffer> <LocalLeader>kh <Esc><Plug>RMakeHTML
map  <buffer> <LocalLeader>kk <Plug>RMakeRmd
imap <buffer> <LocalLeader>kk <Esc><Plug>RMakeRmd
map  <buffer> <LocalLeader>ka <Plug>RMakeAll
imap <buffer> <LocalLeader>ka <Esc><Plug>RMakeAll

function! RmdFoldCodeSections()
    let line = getline(v:lnum)
    let pline = getline(v:lnum - 1)
    if match(line, '\s*```{r') >= 0
        return ">1"
    elseif match(pline, '\s*```$') >= 0
        return "0"
    else
        return "="
    endif
endfunction

function! RmdFoldTextCodeSections()
    let line = getline(v:foldstart)
    let title = substitute(line, '^\s*```{r ', '', '')
    let title = substitute(title, '\W.*$', '', '')
    let title = "##  " . title . "  "
    return title
endfunction

setlocal foldmethod=expr
setlocal foldexpr=RmdFoldCodeSections()
setlocal foldtext=RmdFoldTextCodeSections()
setlocal foldcolumn=2
