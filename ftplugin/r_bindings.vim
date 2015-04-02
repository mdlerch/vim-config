" Start and stop
map  <buffer> <LocalLeader>rf <Plug>RStart
map  <buffer> <LocalLeader>rq :only<CR><BAR><Plug>RClose
map  <buffer> <LocalLeader>ro <Plug>RUpdateObjBrowser

" Send code
map  <buffer> <LocalLeader>l  <Plug>RSendLine
map  <buffer> <LocalLeader>d  <Plug>RDSendLine
map  <buffer> <LocalLeader>pd <Plug>RDSendParagraph
map  <buffer> <LocalLeader>pp <Plug>RSendParagraph
nmap <buffer> <LocalLeader>pe vip<Plug>RSendLine
map  <buffer> <LocalLeader>aa <Plug>RSendFile
nmap <buffer> <LocalLeader>ae ggVG<Plug>RSendLine

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
map <buffer> <LocalLeader>gn :call RAction("names")<CR>
map <buffer> <LocalLeader>gc :call RAction("coef")<CR>
map <leader>ss Isummary(<ESC>A)<ESC>
