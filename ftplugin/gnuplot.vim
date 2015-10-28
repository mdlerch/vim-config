setl nospell

let b:repl_cmd = "gnuplot"
let b:repl_file = "load"
let b:repl_quit = "quit"
let b:repl_syntax = "syntax/gnuplot.vim"

map ,rf :call Repl_start()<CR>
map ,l :call Repl_line()<CR>
map ,rq :call Repl_quit()<CR>
map ,aa :call Repl_file()<CR>
