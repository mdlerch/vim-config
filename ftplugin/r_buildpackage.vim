function! RequirePackage()
    let cwd = split(getcwd(), '/')
    let pkg = cwd[len(cwd) - 1]
    let cmd = "library(\"" . pkg . "\")"
    call g:SendCmdToR(cmd)
endfunction

function! UnlinkPackage()
    let cwd = split(getcwd(), '/')
    let pkg = cwd[len(cwd) - 1]
    let cmd = "detach(\"package:" . pkg . "\", unload = TRUE)"
    call g:SendCmdToR(cmd)
    let cmd = "library.dynam.unload(\"" . pkg . "\", system.file(package = \"" . pkg . "\"))"
    call g:SendCmdToR(cmd)
endfunction

map <buffer> <leader>B :call RequirePackage()<CR>
map <buffer> <leader>U :call UnlinkPackage()<CR>
map <buffer> <leader>C :call g:SendCmdToR("Rcpp::compileAttributes()")<CR>
map <buffer> <leader>L :call g:SendCmdToR("devtools::load_all()")<CR>
map <buffer> <leader>T :call g:SendCmdToR("devtools::test()")<CR>
