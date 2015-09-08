map  <buffer> <LocalLeader>ch <Plug>RESendChunk
map  <buffer> <LocalLeader>cd <Plug>REDSendChunk
map  <buffer> <LocalLeader>ae G<Plug>RSendChunkFH<C-o>

map  <buffer> <LocalLeader>kk <Plug>RMakePDFK
map  <buffer> <LocalLeader>kd <Plug>RMakePDFK
map  <buffer> <LocalLeader>kn <Plug>RKnit

function! BuildDocNoR()
    let cmd = "Rscript -e \""
    if &ft =~ "RMD"
        let cmd = cmd . "rmarkdown::render(\'" . expand('%') . "\')\""
    elseif &ft =~ "RNOWEB"
        let cmd = cmd . "knitr::knit2pdf(\'" . expand('%') . "\')\""
    endif
    call jobstart(cmd)
endfunction


map <buffer> <LocalLeader>kg :call BuildDocNoR()
