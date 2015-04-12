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
endfunction

function! WritingOff()
    let cmd = "set tw=" . b:oldtw
    exe cmd
    bd padding_test
endfunction()
