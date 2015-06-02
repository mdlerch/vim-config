source ~/.vim/ftplugin/r_bindings.vim

setl fo=cl

iabbrev <buffer> -- <-

function! SwitchToHelp()
    let f="man/" . expand("%:t:r") . ".Rd"
    if filereadable(f)
        exe ":e " . f
    endif
endfunction

" map <buffer> <Right> :call SwitchToHelp() <CR>
