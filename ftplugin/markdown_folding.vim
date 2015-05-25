function! MarkdownFoldSection()
    let tline = getline(v:lnum)
    let pline = getline(v:lnum - 1)
    let nline = getline(v:lnum + 1)

    " Headers
    if match(nline, '^====\+') >= 0
        return ">1"
    elseif match(nline, '^----\+') >= 0
        return ">2"
    elseif match(tline, '^### ') >= 0
        return ">3"
    elseif match(tline, '^#### ') >= 0
        return ">4"
    endif

    " Code chunk
    if match(tline, '\s*```{') >= 0
        return "a1"
    elseif match(tline, '\s*```$') >= 0
        return "s1"
    endif

    return "="
endfunction

function! MarkdownFoldText()
    let tline = getline(v:foldstart)
    let foldsize = (v:foldend-v:foldstart)
    let foldlevel = foldlevel(v:foldstart)
    if match(tline, '^\s*```{r ') >= 0
        let title = substitute(tline, '^\s*```{r ', '', '')
        let title = substitute(title, '\W.*$', '', '')
        let title = "## " . title . " (R) " . foldsize . " lines "
    else
        let title = substitute(tline, '#', '', 'g')
        let title = substitute(title, '^[ ]\+\|[ ]\+$', '', 'g')
        let title = "## " . title . " (" . foldlevel . ") " . foldsize . " lines"
    endif
    return title
endfunction

setlocal foldmethod=expr
setlocal foldexpr=MarkdownFoldSection()
setlocal foldtext=MarkdownFoldText()
setlocal foldcolumn=2
