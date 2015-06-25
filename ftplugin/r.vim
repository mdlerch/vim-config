source ~/.vim/ftplugin/r_bindings.vim

setl fo=cl

iabbrev <buffer> -- <-

function! SwitchToHelp()
    let f = expand('%:p:h') . "/../man/" . expand("%:t:r") . ".Rd"
    echo f
    exe ":e " . f
endfunction

map <buffer> <Leader>a :call SwitchToHelp() <CR>
