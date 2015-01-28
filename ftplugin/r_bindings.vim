" Start and stop
map  <buffer> <LocalLeader>rf <Plug>RStart
imap <buffer> <LocalLeader>rf <Esc><Plug>RStart
map  <buffer> <LocalLeader>rq <Plug>RClose
imap <buffer> <LocalLeader>rq <Esc><Plug>RClose
map  <buffer> <LocalLeader>ro <Plug>RUpdateObjBrowser
imap <buffer> <LocalLeader>ro <Esc><Plug>RUpdateObjBrowser

" Send code
map  <buffer> <LocalLeader>l  <Plug>RSendLine
imap <buffer> <LocalLeader>l  <Esc><Plug>RSendLine
map  <buffer> <LocalLeader>d  <Plug>RDSendLine
imap <buffer> <LocalLeader>d  <Esc><Plug>RDSendLine
map  <buffer> <LocalLeader>pd <Plug>RDSendParagraph
imap <buffer> <LocalLeader>pd <Esc><Plug>RDSendParagraph
map  <buffer> <LocalLeader>pe <Plug>RESendParagraph
imap <buffer> <LocalLeader>pe <Esc><Plug>RESendParagraph
map  <buffer> <LocalLeader>aa <Plug>RSendFile
imap <buffer> <LocalLeader>aa <Esc><Plug>RSendFile
map  <buffer> <LocalLeader>ae <Plug>RESendFile
imap <buffer> <LocalLeader>ae <Esc><Plug>RESendFile

" R commands
map  <buffer> <LocalLeader>rh <Plug>RHelp
imap <buffer> <LocalLeader>rh <Esc><Plug>RHelp
map  <buffer> <LocalLeader>rc <Plug>RShowArgs
imap <buffer> <LocalLeader>rc <Esc><Plug>RShowArgs
function! UpdateRdir()
    let filedir = expand('%:p:h')
    let Vimcmd = "call g:SendCmdToR(\"setwd('" . filedir . "')\")"
    :exe Vimcmd
endfunction
map  <buffer><silent> <LocalLeader>rd :call UpdateRdir()<CR>

" Completion
map  <buffer> <C-x>l <Plug>RCompleteArgs
map! <buffer> <C-x>l <Plug>RCompleteArgs

map <buffer> <LocalLeader>gl :call RAction("levels")<CR>
map <buffer> <LocalLeader>gh :call RAction("head")<CR>
map <buffer> <LocalLeader>gs :call RAction("summary")<CR>
map <buffer> <LocalLeader>gp :call RAction("print")<CR>
map <buffer> <LocalLeader>gs :call RAction("str")<CR>
map <buffer> <LocalLeader>gd :call RAction("length")<CR>
map <buffer> <LocalLeader>gn :call RAction("vim.names")<CR>
map <buffer> <LocalLeader>gc :call RAction("coef")<CR>
map <leader>ss Isummary(<ESC>A)<ESC>
