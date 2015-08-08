function! Pandoc(flags, ext)
    let cmd = a:flags . ' -o ' . expand("%:r") . '.' . a:ext . ' ' . expand("%")
    let cmd = 'pandoc ' . cmd
    call jobstart(cmd)
endfunction



" noremap <buffer> <leader>kd <ESC>:w<CR>:!pandoc -N -s % -t latex -o %:r.pdf <CR>
noremap <buffer> <leader>kd <ESC>:w<CR>:call Pandoc("-N -s -t latex", "pdf")<CR>

" noremap <buffer> <leader>kt <ESC>:w<CR>:!pandoc -N -s % -t latex -o %:r.tex <CR>
noremap <buffer> <leader>kt <ESC>:w<CR>:call Pandoc("-N -s -t latex", "tex")<CR>

" noremap <buffer> <leader>kh <ESC>:w<CR>:!pandoc --mathjax -s % -o %:r.html <CR>
noremap <buffer> <leader>kh <ESC>:w<CR>:call Pandoc("--mathjax -s", "html")<CR>

" noremap <buffer> <leader>kr <ESC>:w<CR>:!pandoc % -o %:r.html --mathjax -s -S
        " \ -t revealjs --slide-level 2 -V transition=fade --parse-raw<CR>
noremap <buffer> <leader>kr <ESC>:w<CR>:call Pandoc(
          \ "--mathjax -s -S -t revealjs --slide-level 2 -V transition=fade --parse-raw", "html")<CR>

" noremap <buffer> <leader>kb <ESC>:w<CR>:!pandoc % -o %:r.pdf
"         \ --from markdown-implicit_figures -s -S
"         \ -t beamer --slide-level 2  <CR>
noremap <buffer> <leader>kb <ESC>:w<CR>:call Pandoc(
        \ "--from markdown-implicit_figures -s -S -t beamer --slide-level 2", "pdf")<CR>
