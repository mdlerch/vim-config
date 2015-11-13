let b:repl_cmd = "ipython2"
let b:repl_quit = "quit()"
let b:repl_syntax = "syntax/gnuplot.vim"

map ,rf <Plug>Repl_start
map ,l <Plug>Repl_line
map ,d <Plug>Repl_down
map ,rq <Plug>Repl_quit
map ,aa <Plug>Repl_file
