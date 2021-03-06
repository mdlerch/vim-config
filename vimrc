" vimrc file for Michael Lerch, mdlerch [at] gmail

" {{{1 Functions

" {{{2 Smart close

" Save active buffer.
" If only one window, try to quit vim.
" If multiple windows close the current window.
function! SmartClose()
    " If file is non-modifiable or readonly, etc, delete buffer
    if &readonly || !&modifiable || expand('%:t:r') =~ "test" || &ft =~ "rdoc"
        if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) <= 1
            exe ":q"
        else
            exe ":bd"
        endif
        return 0
    endif

    " One window: write this buffer
    if winnr('$') == 1
        exe ":w"
        " listed buffers, delete this buffer
        if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
            exe ":bd"
        " no listed buffers, quit
        else
            exe ":q"
        endif
    " multiple windows: write this buffer, close window
    else
        exe ":w"
        exe ":close"
    endif
endfunction

" }}}2 Smart close
" {{{2 Dos2unix

" convert endlines from dos to unix
function! Dos2unix()
    :%s///g
endf

" }}}2 Dos2unix
" {{{2 Grab

" place output of vim command into new split
function! Grab(cmd)
    redir => message
    silent exe a:cmd
    redir END
    :10new
    silent put=message
    set nomodified
    set readonly
endfunction
command! -nargs=+ -complete=command Grab call Grab(<q-args>)

" }}}2 Grab
" {{{2 Launchers

" open %r.pdf in pdfviewer
function! LaunchPDF(...)
    let pdfviewer = "zathura"
    if a:0 < 1
        let cmd = pdfviewer . " " . expand("%:r") . ".pdf 2> /dev/null"
    elseif a:0 == 1
        let cmd = pdfviewer . " " . string(a:1) . " 2> /dev/null"
    endif
    call jobstart(cmd)
endfunction
command! -nargs=+ -complete=file_in_path LaunchPDF call LaunchPDF(<q-args>)

function! LaunchPNG(...)
    let pngviewer = "gpicview"
    if a:0 < 1
        let cmd = pngviewer . " " . expand("%:r") . ".png 2> /dev/null"
    elseif a:0 == 1
        let cmd = pngviewer . " " . string(a:1) . " 2> /dev/null"
    endif
    call jobstart(cmd)
endfunction
command! -nargs=+ -complete=file_in_path LaunchPNG call LaunchPNG(<q-args>)


" open %r.html in web browser
function! LaunchHTML(...)
    let htmlviewer = "chromium"
    if a:0 < 1
        let cmd = htmlviewer . " " . expand("%:r") . ".html"
    elseif a:0 == 1
        let cmd = htmlviewer . " " . string(a:1)
    endif
    call jobstart(cmd)
endfunction
command! -nargs=+ -complete=file_in_path LaunchHTML call LaunchHTML(<q-args>)

function! FuzzyLaunch(launcher, ext)
    let sourcer = 'find -iname "*.' . a:ext . '"'
    let sinker = a:launcher
    call fzf#run({'source': sourcer, 'sink': sinker, 'down': '40%',
                \ 'options': '--color dark,pointer:110,hl+:110,bg+:234'})
endfunction

command! -nargs=0 PDFs call FuzzyLaunch('LaunchPDF', 'pdf')
command! -nargs=0 HTMLs call FuzzyLaunch('LaunchHTML', 'html')
command! -nargs=0 PNGs call FuzzyLaunch('LaunchPNG', 'png')

" }}}2 Launchers
" {{{2 Beginning and end of line

" Smart motion to beginning of line
" Move to first non white character on wrapped line.
" Move to first character on wrapped line.
" vis=1 if  in visual mode
function! BigH(vis)
    let oldcol = col('.')
    exe 'norm! g^'
    let newcol = col('.')
    if newcol == oldcol
        exe 'norm! g0'
    endif
    if a:vis == 1
        exe 'norm! m>`>gv'
    endif
endfunction

" Smart motion to end of the line
" Move to last non white character on wrapped line.
" Move to last character on wrapped line.
" vis=1 if  in visual mode
function! BigL(vis)
    let oldcol = col('.')
    exe 'norm! g$'
    if getline('.')[col('.') - 1] =~ '\s'
        exe 'norm! ge'
    endif
    let newcol = col('.')
    if newcol == oldcol
        exe 'norm! g$'
    endif
    if a:vis == 1
        exe 'norm! m>`>gv'
    endif
endfunction

" }}}2 Beginning and end of line
" {{{2 Kill white space

" remove trailing whitespace on current line

function! KillWhiteSpace()
    if &modifiable && !&readonly
        let _s=@/
        s/\s\+$//e
        let @/=_s
    endif
endfunction

" }}}2 Leader x, clear things
" {{{2 term jump

" If a buffer named term:// is in a window, jump to it
" jumps to first term://
function! TermJump()
    for winnum in range(1, winnr('$'))
        if buffer_name(winbufnr(winnum)) =~ "term://"
            let cmd = "normal! " . winnum . "w"
            exe cmd
            return
        endif
    endfor
    for bufnum in range(1, bufnr('$'))
        if buffer_name(bufnum) =~ "term://"
            split
            buffer term://
            return
        endif
    endfor
endfunction

" 2}}}
" {{{2 ToggleMax

" Toggle maximize a window (not what actually happens but recreates)

let g:ToggleMaxPrev = ""

function! ToggleMax()
    " Only window, close if other tabs
    if winnr('$') == 1
        if tabpagenr('$') == 1
            echo "Only tab remaining"
            return
        elseif g:ToggleMaxPrev == ""
            echo "Not a maximized tab"
        else
            close
            let cmd = ":tabn " . g:ToggleMaxPrev
            exe cmd
            let g:ToggleMaxPrev = ""
        endif
    else
        let g:ToggleMaxPrev = tabpagenr()
        :tab sp
    endif
endfunction

" 2}}} ToggleMax

" 1}}} Functions
" {{{1 Options/settings

syntax enable
filetype plugin indent on
set backspace=indent,eol,start

" starting position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
au BufWinEnter GHI_* :1 | set tw=0 | exe "normal! O" | startinsert
au BufWinEnter COMMIT* :1 | exe "normal! O" | startinsert

" misc
set hidden
let no_mail_maps = 1
let g:tex_flavor = "latex"
let fortran_free_source=1
set mouse=ni
" allow increment of alpha characters as well
set nrformats=octal,hex,alpha
set exrc
set secure
let g:sql_type_default = "mysql"

" Default tab settings
set expandtab
set tabstop=4
set softtabstop=0
set shiftwidth=4
set smarttab

" text formatting
set textwidth=80
set formatoptions=clt
set cinoptions+=(0
set cpo+=J
let formatprgs = "set formatprg=par\\ -w" . &tw
exe formatprgs

" grepping
command! -nargs=+ -complete=file_in_path -bar Grep  silent! grep! <args> | copen

if executable("ag")
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column\ --vimgrep
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" vim appearance and behavior
set showcmd
set showmode
set number
set relativenumber
" set listchars=tab:▸\ ,eol:¬,trail:·
set listchars=tab:▸\ ,trail:·
set list
set splitbelow
set splitright
set scrolloff=4
set completeopt=menuone
" set completeopt+=preview
" set completeopt=menu
set spell
if &term =~ "^screen"
    set ttymouse=xterm2
endif
set breakindent
set linebreak
set breakat-=-
set breakat-=@
" two spaces after a period or ? or ! for a new sentence

" vim generated files
set undodir=~/.cache/vim/undodir
set undofile
set swapfile
if has('nvim')
    set shada+=n$HOME/.cache/vim/nviminfo
else
    set viminfo+=n$HOME/.cache/vim/viminfo
endif
let g:netrw_home = expand("$HOME") . "/.cache/"

" searching
set incsearch
set hlsearch
set ignorecase
set smartcase

" timeouts. t=maps tt=keycodes sometimes shell grabs things weirdly
set timeoutlen=700
set ttimeoutlen=10

" more fun to watch turned off -- but does not work well with dragvisuals
set nolazyredraw

" autocomplete this is both in command line mode and in file completion
set wildmode=longest,list,full
set wildmenu
set wildignore+=*.out,*.aux,*.toc,*/undodir/*,*.o,*.log
" set wildignore+=*.jpg,*.png,*.pdf,*.ps,*.eps
set wildignore+=tags

" where to look for include headers
set path+=/home/mike/R/x86_64-unknown-linux-gnu-library/3.1/Rcpp/include/**
set path+=/home/mike/R/x86_64-unknown-linux-gnu-library/3.1/RcppArmadillo/include/**
set path+=/usr/include/R/**

" session vars
set sessionoptions+=tabpages,globals

" 1}}} Options/settings
" {{{1 Maps

" leaders
let mapleader=","
let maplocalleader=","

nnoremap Y y$

" very magic
nnoremap / /\v
vnoremap / /\v

" buffer operations
" noremap QQ <ESC>:qall<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :call SmartClose()<CR>
inoremap <leader>w <ESC>:w<CR>
inoremap <leader>q <ESC>:call SmartClose()<CR>
nnoremap <leader>Q :wqall<CR>
inoremap <leader>Q <ESC>:wqall<CR>
noremap <leader>x :pclose <BAR> :nohls<CR>

" terminal
if has('nvim')
    tnoremap <leader><leader> <C-\><C-n>
    tnoremap <C-w>h <C-\><C-n><C-w>h
    tnoremap <C-w>j <C-\><C-n><C-w>j
    tnoremap <C-w>k <C-\><C-n><C-w>k
    tnoremap <C-w>l <C-\><C-n><C-w>l
    tnoremap <C-w>H <C-\><C-n><C-w>H
    tnoremap <C-w>J <C-\><C-n><C-w>J
    tnoremap <C-w>K <C-\><C-n><C-w>K
    tnoremap <C-w>L <C-\><C-n><C-w>L
    nnoremap <leader>tt :call TermJump()<CR>
    tnoremap gt <C-\><C-n>gt
    augroup TERMBUFFER
        autocmd!
        autocmd TermOpen * setlocal nospell | setlocal nocursorline
        " autocmd BufEnter term://* startinsert
    augroup END
endif

" Number increment/decrement
if !has('nvim')
    set <A-a>=a
    set <A-x>=x
endif
nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>
vnoremap <silent> <A-a> :s/\%V-\=\d\+/\=submatch(0)+1/g<CR>gv
vnoremap <silent> <A-x> :s/\%V-\=\d\+/\=submatch(0)-1/g<CR>gv

" prevent accidents (I never use these default commands)
nnoremap <C-a> <NOP>
vnoremap <C-a> <NOP>
inoremap <C-a> <NOP>
" noremap q/ <NOP>
nnoremap K <NOP>
nnoremap Q <NOP>
" too lazy to press shift
noremap ; :

" motions
noremap <expr>j (v:count ? 'j' : 'gj')
noremap <expr>k (v:count ? 'k' : 'gk')
noremap gj j
noremap gk k
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz
nnoremap - ;
nnoremap _ ,
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>
nnoremap ]l :lnext<CR>
nnoremap [l :lprevious<CR>
nnoremap <down> +
nnoremap <up> -
nnoremap H :call BigH(0)<CR>
xnoremap H <ESC>:call BigH(1)<CR>
nnoremap L :call BigL(0)<CR>
xnoremap L <ESC>:call BigL(1)<CR>
nnoremap n nzzzxzv
nnoremap N Nzzzxzv

" formatting
vnoremap < <gv
vnoremap > >gv
nnoremap <leader>SS gg:%!git stripspace<CR><C-o>

" folds
noremap <silent> <space> za
set foldlevel=1
noremap <F9> zm
noremap <F10> zr
noremap <F11> zMzv
noremap ]z zj

" built-in calculator
let pi = 3.14159265359
let e  = 2.71828182846
vnoremap <leader>e ygvc<C-r>=<C-r>"<CR><ESC>

" resync syntax
nnoremap <F12> :redraw!<CR>:syntax sync fromstart<CR>

" apply last command to all lines in visual selection
vnoremap . :normal . <CR>

" shorthand functions
cabbr setwd :cd %:h<CR>:pwd<CR>
cabbr d2u :call Dos2unix()

" too lazy for esc
inoremap <C-w> <ESC><C-w>
inoremap <leader><leader> <C-[>
vnoremap <leader><leader> <C-[>
nnoremap <leader><leader> <C-[>
cnoremap <leader><leader> <C-c>

" tags
noremap <leader>ts <C-w><C-]>
noremap <leader>tj <C-]>
noremap <leader>tr :!ctags -R<CR>
set tags=./tags;

" Quick spell fix
noremap <leader>z [s1z=<C-o>
inoremap <leader>z <C-g>u<ESC>[s1z=`]a<C-g>u
" noremap <leader>z [sh1z=<C-o>
" inoremap <leader>z <C-g>u<ESC>[s1hz=`]a<C-g>u

" My function maps
nmap <F5> :call WritingToggle()<CR>
nmap gs :call KillWhiteSpace()<CR>
nmap <C-w>m :call ToggleMax()<CR>

" information
nnoremap <leader>W m[ggVGg<C-g><Esc>`[

function! ListFKeys()
    let message = "F1 neomake! make (all) \n" .
                \ "F2 neomake! clean \n" .
                \ "F3 set in project? \n" .
                \ "F4 neomake! diff \n" .
                \ "F5 WritingToggle \n" .
                \ "F6 NONE \n" .
                \ "F7 NONE\n" .
                \ "F8 NONE\n" .
                \ "F9 close all folds \n" .
                \ "F10 open all folds \n" .
                \ "F11 redo folding \n" .
                \ "F12 re-sync syntax \n"
    :12new
    silent put=message
    set nomodified
    set readonly
endfunction

map <leader>F :call ListFKeys()<CR>

" 1}}} Maps
" {{{1 Plugins

call plug#begin('~/.vim/bundle')

" misc
Plug 'tpope/vim-repeat'
" autocomplete
" {{{2 (deoplete)

" Plug 'Shougo/deoplete.nvim'

let g:deoplete#enable_at_startup = 1

let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.r = ['\w\+\$\w*']

let g:deoplete#sources = {}
let g:deoplete#sources._ = ['buffer']
let g:deoplete#sources.r = ['buffer', 'tag', 'omni']

" inoremap <expr><Tab>  deoplete#mappings#manual_complete()
" inoremap <expr><C-h> deolete#mappings#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"

" 2}}} deoplete
" {{{2 YouCompleteMe

Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --clang-completer --system-libclang' }

let g:ycm_filetype_blacklist = {
    \ 'tagbar' : 1,
    \ 'qf' : 1,
    \ 'notes' : 1,
    \ 'unite' : 1,
    \ 'vimwiki' : 1,
    \ }
" I have removed: text, markdown, pandoc

let g:ycm_global_ycm_extra_conf = '~/.vim/ycm/rcpp_ycm_conf.py'
let g:ycm_show_diagnostics_ui = 0
let g:ycm_cache_omnifunc = 0
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_key_list_select_completion = ['<TAB>', '<DOWN>']
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_extra_conf_globlist = ['./*']
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_add_preview_to_completeopt = 0

let g:ycm_semantic_triggers =  {
\   'c' : ['->', '.'],
\   'objc' : ['->', '.'],
\   'ocaml' : ['.', '#'],
\   'cpp,objcpp' : ['->', '.', '::'],
\   'perl' : ['->'],
\   'php' : ['->', '::'],
\   'cs,java,javascript,d,python,perl6,scala,vb,elixir,go' : ['.'],
\   'vim' : ['re![_a-zA-Z]+[_\w]*\.'],
\   'ruby' : ['.', '::'],
\   'lua' : ['.', ':'],
\   'erlang' : [':'],
\ }

" 2}}} YouCompleteMe
" {{{2 UltiSnips

Plug 'sirver/ultisnips'

let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"

let g:UltiSnipsUsePythonVersion=2

" 2}}} UltiSnips
" color
Plug 'git@github.com:mdlerch/tungsten.vim.git'
Plug 'git@github.com:mdlerch/yttrium.vim.git'
Plug 'gerw/vim-HiLinkTrace'
Plug 'jnurmine/Zenburn'
" {{{2 Rainbow

Plug 'git@github.com:mdlerch/rainbow_parentheses.vim'
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

augroup rainbowparens
  autocmd!
  autocmd FileType r,cpp,vim,sql,python RainbowParentheses
augroup END

let g:rainbow#colors = {
\   'dark': [
\     ['229', '#ffffaf'],
\     ['110', '#87afd7'],
\     ['180', '#dfaf87'],
\     ['108', '#87af87'],
\     ['103', '#8787af'],
\     ['167', '#d75f5f'],
\     ['227', '#ffff5f'],
\     [ '38', '#00afd7'],
\     ['208', '#ff8700'],
\     ['113', '#87d75f'],
\     [ '99', '#875fff'],
\     ['162', '#d70087']
\   ],
\   'light': [
\     ['229', '#ffffaf'],
\     ['110', '#87afd7'],
\     ['180', '#dfaf87'],
\     ['108', '#87af87'],
\     ['103', '#8787af'],
\     ['167', '#d75f5f'],
\     ['162', '#d70087'],
\     ['227', '#ffff5f'],
\     [ '38', '#00afd7'],
\     ['208', '#ff8700'],
\     ['113', '#87d75f'],
\     [ '99', '#875fff'],
\     ['162', '#d70087']
\   ]
\ }

" 2}}} Rainbow
" {{{2 interesting words

Plug 'vasconcelloslf/vim-interestingwords'

nnoremap <silent> <leader>k <Plug>InterestingWords
nnoremap <silent> <leader>K <Plug>InterestingWordsClear

" 2}}} interesting words
" filetype
Plug 'git@github.com:mdlerch/vim-markdown.git'
Plug 'git@github.com:mdlerch/vim-julia.git'
Plug 'git@github.com:mdlerch/mc-stan.vim.git'
Plug 'git@github.com:mdlerch/psql.nvim'
Plug 'git@github.com:mdlerch/R-Vim-runtime.git'
Plug 'keith/tmux.vim'
Plug 'vim-scripts/gnuplot.vim'
Plug 'justinmk/vim-syntax-extra'
" {{{2 Vim-R-Plugin

Plug 'git@github.com:mdlerch/Nvim-R.git'

" let R_term = "roxterm"
let R_term_cmd = "roxterm"
let R_in_buffer = 1
let R_hl_term = 1
let R_setwidth = 1
let R_assign = 0
" let R_assign_map = "<space>--<space>"
let R_rnowebchunk = 0
let R_objbr_place = "script,right"
" let R_objbr_w = 30
let R_tmux_ob = 1
let R_nvimpager = "horizontal"
" let R_editor_w = 80
" let R_help_w = 60
" let R_path = "/usr/bin"
let R_args = ['--no-save',' --no-restore-data']
let R_start_libs = "base,stats,graphics,grDevices,utils,methods,rlerch"
" let R_routmorecolors = 1
" let R_routnotab = 0
" let R_indent_commented = 1
let R_notmuxconf = 1
let R_rconsole_height = 15
" let R_vsplit = 0
" let R_rconsole_width 50
let R_tmux_title = "automatic"
" let R_applescript = 0
let R_listmethods = 1
" let R_specialplot = 0
" let R_maxdeparse = 300
let R_latexcmd = "texi2pdf"
" let R_sweaveargs = ""
" let R_rmd_environment = ".GlobalEnv"
" let R_never_unmake_menu = 0
let R_ca_ck = 1
let R_pdfviewer = "zathura"
let R_openpdf = 0
let R_openhtml = 0
" R_strict_rst = 0
let R_insert_mode_cmds = 0
let R_allnames = 1
let R_rmhidden = 1
" let R_source = ""
let R_restart = 1
let R_show_args = 1
" R_nvimcom_wait = 5000
let R_nvim_wd = 1
let R_user_maps_only = 1
let R_tmpdir = "/dev/shm/R_tmp_dir"
let R_compldir = "~/.cache/Nvim-R"
let R_synctex = 0

let rout_follow_colorscheme = 1

" }}}2 Vim-R-Plugin
" {{{2 vim-cpp-enhanced-highlight

Plug 'octol/vim-cpp-enhanced-highlight'

let g:cpp_class_scope_highlight = 1

" 2}}} vim-cpp-enhanced-highlight
" {{{2 TagHighlight

Plug 'abudden/taghighlight-automirror'

if ! exists('g:TagHighlightSettings')
    let g:TagHighlightSettings = {}
endif
let g:TagHighlightSettings['ForcedPythonVariant'] = 'if_pyth'

hi link CTagsDefinedName function

" }}}2 TagHighlight
" run commands
" {{{2 neomake

Plug 'benekastah/neomake'

augroup NEOMAKEFILETYPES
    autocmd!
    autocmd BufWritePost *.py Neomake
    autocmd BufReadPost *.py Neomake
    autocmd BufWinEnter *.py sign define dummy
    autocmd BufWinEnter *.py execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

    autocmd BufWritePost *.cpp Neomake
    autocmd BufReadPost *.cpp Neomake
    autocmd BufWinEnter *.cpp sign define dummy
    autocmd BufWinEnter *.cpp execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

    " autocmd BufWritePost *.R,*.r Neomake
    " autocmd BufReadPost *.R,*.r Neomake
    " autocmd BufWinEnter *.R,*.r sign define dummy
    " autocmd BufWinEnter *.R,*.r execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
augroup END

map <F1> :Neomake! make<CR>
map <F2> :Neomake! clean<CR>
" set <F3> in project vimrc
map <F4> :Neomake! diff<CR>

let g:neomake_error_sign = {
    \ 'text': '⚫',
    \ 'texthl': 'ErrorMsg',
    \ }
let g:neomake_warning_sign = {
    \ 'text': '⚫',
    \ 'texthl': 'WarningMsg',
    \ }

let g:neomake_make_maker = {
    \ 'exe': 'make',
    \ 'args': ['all'],
    \ 'buffer_output': 1,
    \ 'remove_invalid_entries': 0
    \ }

let g:neomake_clean_maker = {
    \ 'exe': 'make',
    \ 'args': ['clean'],
    \ 'remove_invalid_entries': 0
    \ }

let g:neomake_diff_maker = {
    \ 'exe': 'make',
    \ 'args': ['diff'],
    \ 'remove_invalid_entries': 0
    \ }

let g:neomake_python_pylint_maker = {
    \ 'exe': 'pylint2',
    \ 'args': [
        \ '--rcfile=/home/mike/.pylintrc',
        \ '-f', 'text',
        \ '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg}"',
        \ '-r', 'n'
        \ ],
    \ 'errorformat':
        \ '%A%f:%l:%c:%t: %m,' .
        \ '%A%f:%l: %m,' .
        \ '%A%f:(%l): %m,' .
        \ '%-Z%p^%.%#,' .
        \ '%-G%.%#',
    \ }

let g:neomake_python_enabled_makers = ['pylint']

let s:RcppArmadilloInclude =
    \ "/home/mike/R/x86_64-unknown-linux-gnu-library/3.2/RcppArmadillo/include/"
let s:RcppInclude =
    \ "/home/mike/R/x86_64-unknown-linux-gnu-library/3.2/Rcpp/include/"
let s:RInclude = "/usr/include/R/"
let s:RextInclude = "/usr/include/R/R_ext/"

let g:neomake_cpp_clang_maker = {
    \ 'exe': 'clang++',
    \ 'args': [
        \ '-I' . s:RcppArmadilloInclude,
        \ '-I' . s:RcppInclude,
        \ '-I' . s:RInclude,
        \ '-I' . s:RextInclude,
        \ '-fsyntax-only',
        \ ],
    \ 'errorformat':
        \ '%-G%f:%s:,' .
        \ '%-G%f:%l: %#error: %#(Each undeclared identifier is reported only%.%#,' .
        \ '%-G%f:%l: %#error: %#for each function it appears%.%#,' .
        \ '%-GIn file included%.%#,' .
        \ '%-G %#from %f:%l\,,' .
        \ '%f:%l:%c: %trror: %m,' .
        \ '%f:%l:%c: %tarning: %m,' .
        \ '%f:%l:%c: %m,' .
        \ '%f:%l: %trror: %m,' .
        \ '%f:%l: %tarning: %m,'.
        \ '%f:%l: %m',
    \ }

let g:neomake_cpp_enabled_makers = ['clang']

let g:neomake_r_lintr_maker = {
    \ 'exe': 'lintr',
    \ 'args': [],
    \ 'errorformat':
    \ '%W%f:%l:%c: style: %m,' .
    \ '%W%f:%l:%c: warning: %m,' .
    \ '%E%f:%l:%c: error: %m',
    \ }

" let g:neomake_r_enabled_makers = ['lintr']

" 2}}} neomake
Plug 'git@github.com:mdlerch/repl.nvim.git'
" narrower
" {{{2 fzf

Plug 'junegunn/fzf', { 'dir': '~/bin/fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

map <leader>f :exe 'Files ' . <SID>fzf_root()<CR>
map <leader>b :Buffers<CR>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_height = '20%'

function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=180 ctermbg=234
  highlight fzf2 ctermfg=110 ctermbg=234
  highlight fzf3 ctermfg=196 ctermbg=234
  setlocal statusline=%#fzf1#>>>>\ %#fzf2#fz%#fzf1#f\ narrower
endfunction

fun! s:fzf_root()
    let path = finddir(".git", expand("%:p:h").";")
    return fnamemodify(substitute(path, ".git", "", ""), ":p:h")
endfun

autocmd VimEnter * command! -bang -nargs=* Ag
    \ call fzf#vim#ag(<q-args>, {'down': '40%', 'options':
    \ '--color dark,pointer:110,hl+:110,bg+:234'})

autocmd VimEnter * command! -bang -nargs=* Files
    \ call fzf#vim#files(<q-args>, {'down': '40%', 'options':
    \ '--color dark,pointer:110,hl+:110,bg+:234 --prompt "> "'})

autocmd VimEnter * command! -bang -nargs=* Buffers
    \ call fzf#vim#buffers({'down': '40%', 'options':
    \ '--color dark,pointer:110,hl+:110,bg+:234'})

autocmd VimEnter * command! -bang -nargs=* BLines
    \ call fzf#vim#buffer_lines({'down': '40%', 'options':
    \ '--color dark,pointer:110,hl+:110,bg+:234'})

autocmd VimEnter * command! -bang -nargs=* Tags
    \ call fzf#vim#tags({'down': '40%', 'options':
    \ '--color dark,pointer:110,hl+:110,bg+:234'})

autocmd! User FzfStatusLine call <SID>fzf_statusline()

" 2}}} fzf
" {{{2 (ctrlp)

" Plug 'kien/ctrlp.vim'

" Use <C-f> to switch mode

" let g:ctrlp_map = '<leader>f'
" nnoremap <leader>b :CtrlPBuffer<CR>
" let g:ctrlp_extensions = ['tag']
" let g:ctrlp_working_path_mode = 'rw'
" let g:ctrlp_show_hidden = 1
" let g:ctrlp_max_depth = 10
" let g:ctrlp_open_new_file = 'r'
" let g:ctrlp_prompt_mappings = {
"     \ 'CreateNewFile()': ['<F2>']
"     \ }

" hi CtrlPMode1 ctermbg=238 ctermfg=180

" 2}}} ctrlp
" writing
Plug 'tpope/vim-abolish'
" {{{2 vim-wordy

Plug 'reedes/vim-wordy'

" use :NextWordy<CR> to start

" Dictionaries:
" ~/vim-bundle/vim-wordy/data/en/art-jargon.dic
" ~/vim-bundle/vim-wordy/data/en/being.dic
" ~/vim-bundle/vim-wordy/data/en/business-jargon.dic
" ~/vim-bumdle/vim-wordy/data/en/colloquial.dic
" ~/vim-bundle/vim-wordy/data/en/contractions.dic
" ~/vim-bundle/vim-wordy/data/en/idiomatic.dic
" ~/vim-bundle/vim-wordy/data/en/opinion.dic
" ~/vim-bundle/vim-wordy/data/en/passive-voice.dic
" ~/vim-bundle/vim-wordy/data/en/problematic.dic
" ~/vim-bundle/vim-wordy/data/en/puffery.dic
" ~/vim-bundle/vim-wordy/data/en/redundant.dic
" ~/vim-bundle/vim-wordy/data/en/said-synonyms.dic
" ~/vim-bundle/vim-wordy/data/en/similies.dic
" ~/vim-bundle/vim-wordy/data/en/vague-time.dic
" ~/vim-bundle/vim-wordy/data/en/weak.dic
" ~/vim-bundle/vim-wordy/data/en/weasel.dic

let g:wordy#ring = [
    \ ['opinion', 'vague-time', 'weasel'],
    \ ['passive-voice'],
    \ ['problematic', 'redundant', 'similies'],
    \ ['weak'],
    \ ['puffery'],
    \ ['contractions'],
    \ ]

" 2}}} vim-wordy
" {{{2 editing

Plug 'dhruvasagar/vim-table-mode'
Plug 'tommcdo/vim-exchange'
" {{{2 vim-commentary

Plug 'tpope/vim-commentary'

imap <leader>cc <C-g>u<ESC><Plug>CommentaryLine
nmap <leader>cc <Plug>CommentaryLine
vmap <leader>cc <Plug>Commentary

augroup VIMCOMMENTARY
    autocmd!
    autocmd FileType r setl commentstring=#\ %s
    autocmd FileType rmd setl commentstring=#\ %s
    autocmd FileType rnoweb setl commentstring=#\ %s
    autocmd FileType markdown setl commentstring=<!--\ %s\ -->
    autocmd FileType gnuplot setl commentstring=#\ %s
    autocmd FileType cpp setl commentstring=//\ %s
    autocmd FileType c setl commentstring=//\ %s
    autocmd FileType sql setl commentstring=--\ %s
augroup END

" 2}}} vim-commentary
" {{{2 vim-surround

Plug 'tpope/vim-surround'

let g:surround_no_mappings = 1

nmap ys <Plug>Ysurround
nmap Sd <Plug>Dsurround
nmap Sc <Plug>Csurround
nmap Sw ysiw
nmap SW ysiW
nmap Sa <Plug>Ysurround
nmap Sl <Plug>Yssurround
xmap Sa <Plug>VSurround

" 2}}} vim-surround
" {{{2 DragVisuals

vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()

" 2}}} DragVisuals
" {{{2 Tabularize

Plug 'godlygeek/tabular'

vnoremap <leader>& :Tabularize /&<CR>

" 2}}} Tabularize
" {{{2 undotree

Plug 'mbbill/undotree'

let g:undotree_WindowLayout = 3
let g:undotree_SplitWidth = 40

" }}}2 undotree
" {{{2 clever-f

Plug 'rhysd/clever-f.vim'

" 2}}}
" {{{2 fugitive

Plug 'tpope/vim-fugitive'

" 2}}}
" {{{2 noscrollbar

Plug 'gcavallanti/vim-noscrollbar'

" 2}}} noscrollbar

call plug#end()

" 1}}} Plugins
" {{{1 Color and appearance

" Gvim settings
set guifont=Inconsolata\ LGC\ Bold\ 10

" colorcolumn
set colorcolumn=+1
" let &colorcolumn="+".join(range(1,200),",+")

set cursorline

" color scheme
" set background=dark
colorscheme tungsten

" additional highlighting
"highlight Comment cterm=italic gui=italic
hi def link gitcommitOverflow Error

if g:colors_name=="zenburn"
    highlight SpecialKey ctermfg=238
endif

highlight ExtraWhitespace ctermfg=red guifg=red
match ExtraWhitespace /\s\+$/
" in insert mode do not highlight in current line
augroup WHITESPACE
    autocmd!
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
augroup END

function! UnmatchWhite()
    highlight ExtraWhitespace ctermfg=None guifg=None
endfunction

augroup UNMATCHWHITERBROWSER
    autocmd!
    autocmd FileType rbrowser call UnmatchWhite()
augroup END

highlight MatchParen cterm=NONE

" 1}}} Color and appearance
" {{{1 Statusline

set laststatus=2

augroup status
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * call <SID>DoStatusLine()
augroup END

function! s:DoStatusLine()
    for winnum in range(1, winnr('$'))
        call setwinvar(winnum, '&statusline', '%!SetStatusLine(' . winnum . ')')
    endfor
endfunction

hi User1 ctermbg=234 ctermfg=110 guibg=#1c1c1c guifg=#87afd7
hi User2 ctermbg=238 ctermfg=180 guibg=#444444 guifg=#dfaf87
hi User3 ctermbg=234 ctermfg=196 guibg=#1c1c1c guifg=#ff0000
hi User4 ctermbg=238 ctermfg=234 guibg=#444444 guifg=#87afd7
hi User5 ctermbg=238 ctermfg=234 guibg=#444444 guifg=#87afd7
hi User6 ctermbg=238 ctermfg=234 guibg=#444444 guifg=#87afd7

function! SetStatusLine(winnum)
    let unactive = !(a:winnum == winnr())

    function! StatusColor(num, unactive)
        let shift = 0
        if a:unactive
            let shift = shift + 3
        endif
        let col = a:num + shift
        let out = "%" . col . "*"
        return out
    endfunction

    function! PrintSQLCalls()
        if exists("g:PSQLcalls") && &ft =~ "sql"
            return g:PSQLcalls
        endif
        if !exists("g:PSQLcalls") && &ft =~ "sql"
            return 0
        endif
        return ""
    endfunction

    let thefilename = expand('%')

    let statline=""
    if winwidth(0) > 100
        let statline.=StatusColor(2, unactive)
        let statline.='%{fugitive#statusline()}'  " git branch
    endif
    let statline.=StatusColor(1, unactive)
    let statline.=' '            " space
    if len(thefilename) < 30
        let statline.='%f '          " relative filename
    else
        let statline .= '///' . '%t '
    endif
    let statline.=StatusColor(3, unactive)
    let statline.='%R '           " readonly
    let statline.='%m '           " modified
    let statline.=StatusColor(1, unactive)
    let statline.='%='
    if winwidth(0) > 100
        let statline.='%{&fileencoding?&fileencoding:&encoding}'
    endif
    let statline.=' '            " space
    let statline.=StatusColor(2, unactive)
    let statline.=' %Y '         " filetype
    let statline.=PrintSQLCalls()
    let statline.=StatusColor(1, unactive)
    if winwidth(0) > 100
        let statline.=' %{noscrollbar#statusline(20,"-","=")}'
    endif
    let statline.=' %5l:%-3c'         " line and column
    let statline.=' [%L]'        " total lines
    return statline
endfunction

" 1}}} Statusline

" let rmd_syn_hl_chunk=1
" vim:fdm=marker:foldlevel=0
