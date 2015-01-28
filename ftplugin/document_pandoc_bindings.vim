noremap <buffer> <leader>kd <ESC>:w<CR>:!pandoc -N -s % -t latex -o %:r.pdf <CR>
inoremap <buffer> <leader>kd <ESC>:w<CR>:!pandoc -N -s % -t latex -o %:r.pdf <CR>

noremap <buffer> <leader>kt <ESC>:w<CR>:!pandoc -N -s % -t latex -o %:r.tex <CR>
inoremap <buffer> <leader>kt <ESC>:w<CR>:!pandoc -N -s % -t latex -o %:r.tex <CR>

noremap <buffer> <leader>kh <ESC>:w<CR>:!pandoc --mathjax -s % -o %:r.html <CR>
inoremap <buffer> <leader>kh <ESC>:w<CR>:!pandoc --mathjax -s % -o %:r.html <CR>

noremap <buffer> <leader>kr <ESC>:w<CR>:!pandoc % -o %:r.html --mathjax -s -S
        \ -t revealjs --slide-level 2 -V transition=fade --parse-raw<CR>
inoremap <buffer> <leader>kr <ESC>:w<CR>:!pandoc % -o %:r.html --mathjax -s -S
        \ -t revealjs --slide-level 2 -V transition=fade --parse-raw<CR>
