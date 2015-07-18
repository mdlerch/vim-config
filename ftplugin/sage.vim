let b:repl_cmd = "sage"
let b:repl_quit = "quit()"

map ,rf :call Repl_start()<CR>
map ,l :call Repl_line()<CR>
map ,rq :call Repl_quit()<CR>
