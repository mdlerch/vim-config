function! IsReply()
    if line('$') > 1
        " Strip old signature
        :g/^>\s\=--\s\=$/,$ delete
        :%!par w72q
        " Begin with 1+ >, then 1+ characters then end of line, add space
        :%s/^>\+.\+$/\0 /e
        " Begin with 1+ >, then match any number of whitespace, remove spaces
        :%s/^>\+\zs\s$//e
        " Begin with 1+>, then 1+ characters, then end of line, then newline
        " with only 1+>, remove end of line space
        :%s/\s\+\ze\n>\+$//e
        :1
        :put! =\"\n\n\"
        :1
    endif
endfunction

augroup mail_filetype
    autocmd!
    autocmd VimEnter /tmp/mutt* :call IsReply()
    autocmd VimEnter /tmp/mutt* :exe 'startinsert'
augroup END

setl tw=72
setl wrap linebreak
