function! WritingOn()
    let b:oldtw=&tw
    let mainwindow=winnr()
    let mycolumns = &tw + &numberwidth + &foldcolumn
    vnew padding_test
    setlocal ro
    let cmd = "normal! " . mainwindow . "w"
    exe cmd
    set tw=0
    let cmd = "vertical resize" . mycolumns
    exe cmd
    let b:writing_on = 1
endfunction

function! WritingOff()
    let cmd = "set tw=" . b:oldtw
    exe cmd
    bd padding_test
    let b:writing_on = 0
endfunction()

function! WritingToggle()
    if !exists("b:writing_on") || b:writing_on == 0
        call WritingOn()
    elseif b:writing_on == 1
        call WritingOff()
    endif
endfunction
