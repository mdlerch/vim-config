function! SwitchToScript()
    let f="R/" . expand("%:t:r") . ".R"
    if filereadable(f)
        exe ":e " . f
    endif
endfunction

map <buffer> <Right> :call SwitchToScript() <CR>
