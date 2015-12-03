map  <buffer> <LocalLeader>ch <Plug>RESendChunk
map  <buffer> <LocalLeader>cd <Plug>REDSendChunk
map  <buffer> <LocalLeader>ae G<Plug>RSendChunkFH<C-o>

map  <buffer> <LocalLeader>kk <Plug>RMakePDFK
map  <buffer> <LocalLeader>kd <Plug>RMakePDFK
map  <buffer> <LocalLeader>kn <Plug>RKnit

function! BuildDocNoRExit(job_id, data)
    if a:data == 0
        echom 'Build successful'
    else
        echom 'Build fail' . string(a:data)
    endif
endfunction

function! BuildDocNoR()
    let cmd = "Rscript -e \""
    if &ft =~ "RMD"
        let cmd = cmd . "library(rmarkdown); render(\'" . expand('%') . "\')\""
    elseif &ft =~ "RNOWEB"
        let cmd = cmd . "library(knitr); knit2pdf(\'" . expand('%') . "\')\""
    endif
    call jobstart(cmd, {'on_exit': 'g:BuildDocNoRExit'})
endfunction


map <buffer> <LocalLeader>kg :call BuildDocNoR()<CR>
