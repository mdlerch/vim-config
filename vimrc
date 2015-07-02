" vimrc file for Michael Lerch, mdlerch [at] gmail

" {{{1 Vim-Plug ==========================================

call plug#begin('~/.vim/bundle')

"" completion
Plug 'sirver/ultisnips'
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --clang-completer --system-libclang' }

" tools
Plug 'benekastah/neomake'
Plug 'gcavallanti/vim-noscrollbar'
Plug 'godlygeek/tabular'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree'
Plug 'reedes/vim-wordy'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'amoffat/snake'

" file tools
Plug 'kien/ctrlp.vim'
Plug 'rking/ag.vim'

" filetype and syntax
Plug 'git@github.com:mdlerch/vim-gnuplot.git'
Plug 'git@github.com:mdlerch/vim-markdown.git'
Plug 'git@github.com:mdlerch/vim-julia.git'
Plug 'git@github.com:mdlerch/vim-mc-stan.git'
Plug 'git@github.com:mdlerch/Nvim-R.git'
Plug 'abudden/taghighlight-automirror'
Plug 'justinmk/vim-syntax-extra'
Plug 'vim-scripts/gnuplot.vim'

" colorschemes
" Plug 'kien/rainbow_parentheses.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'git@github.com:mdlerch/vim-tungsten.git'
Plug 'git@github.com:mdlerch/vim-yttrium.git'
" Plug 'git@github.com:mdlerch/rainbow'
Plug 'gerw/vim-HiLinkTrace'
Plug 'romainl/Apprentice'
Plug '29decibel/codeschool-vim-theme'

call plug#end()

" }}}1 vim-plug  ==========================================
" {{{1 Functions =========================================

" {{{2 Smart close =======================================

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

" }}}2 Smart close =======================================
" {{{2 Dos2unix ==========================================

" convert endlines from dos to unix
function! Dos2unix()
    :%s///g
endf

" }}}2 Dos2unix ==========================================
" {{{2 Grab ==============================================

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

" }}}2 Grab ==============================================
" {{{2 Launchers =========================================

" open %r.pdf in pdfviewer
function! LaunchPDF()
    let pdfviewer = "zathura"
    let cmd = "! " . pdfviewer . " " . expand("%:r") . ".pdf 2> /dev/null &"
    exe cmd
endfunction

" open %r.html in web browser
function! LaunchHTML()
    let htmlviewer = "chromium"
    let cmd = "!" . htmlviewer . " " . expand("%:r") . ".html &"
    exe cmd
endfunction

" }}}2 Launchers =========================================
" {{{2 Beginning and end of line =========================

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
    exe 'norm! B'
    exe 'norm! E'
    let newcol = col('.')
    if newcol == oldcol
        exe 'norm! g$'
    endif
    if a:vis == 1
        exe 'norm! m>`>gv'
    endif
endfunction

" }}}2 Beginning and end of line =========================
" {{{2 Leader x, clear things ============================

" Take care of a bunch of annoying things all in one function
" remove trailing whitespace on current line
" close preview window
" would be nice to also nohl, but doesn't work in a function (see help function)
function! LeaderX()
    pclose
    if &modifiable && !&readonly
        let _s=@/
        s/\s\+$//e
        let @/=_s
    endif
endfunction


" }}}2 Leader x, clear things ============================
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

" }}}1 Functions =========================================
" {{{1 Options/settings ==================================

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
set cpo+=J

" vim generated files
set undodir=~/.cache/vim/undodir
set undofile
set swapfile
set viminfo+=n$HOME/.cache/vim/viminfo
let g:netrw_home = "~/.cache/"

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
set wildignore+=*.jpg,*.png,*.pdf,*.ps,*.eps
set wildignore+=tags

" where to look for include headers
set path+=/home/mike/R/x86_64-unknown-linux-gnu-library/3.1/Rcpp/include/**
set path+=/home/mike/R/x86_64-unknown-linux-gnu-library/3.1/RcppArmadillo/include/**
set path+=/usr/include/R/**

" session vars
set sessionoptions+=tabpages,globals

" }}}1 Options/settings ==================================
" {{{1 Color and appearance ==============================

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

" }}} 1 Color and appearance
" {{{1 statusline ========================================

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

hi User1 ctermbg=234 ctermfg=110 guibg=1c1c1c guifg=87afd7
hi User2 ctermbg=238 ctermfg=180 guibg=444444 guifg=dfaf87
hi User3 ctermbg=234 ctermfg=196 guibg=1c1c1c guifg=ff0000
hi User4 ctermbg=238 ctermfg=234 guibg=444444 guifg=87afd7
hi User5 ctermbg=238 ctermfg=234 guibg=444444 guifg=dfaf87
hi User6 ctermbg=238 ctermfg=234 guibg=444444 guifg=ff0000

function! SetStatusLine(winnum)
    let active = !(a:winnum == winnr())

    function! StatusColor(num, active)
        let shift = 0
        if a:active
            let shift = shift + 3
        endif
        let col = a:num + shift
        let out = "%" . col . "*"
        return out
    endfunction

    let statline=""
    let statline.=StatusColor(2, active)
    let statline.='%{fugitive#statusline()}'  " git branch
    let statline.=StatusColor(1, active)
    let statline.=' '            " space
    let statline.='%f '          " relative filename
    let statline.=StatusColor(3, active)
    let statline.='%R '           " readonly
    let statline.='%m '           " modified
    let statline.=StatusColor(1, active)
    let statline.='%='
    let statline.='%{&fileencoding?&fileencoding:&encoding}'
    let statline.=' '            " space
    let statline.=StatusColor(2, active)
    let statline.=' %Y '         " filetype
    let statline.=StatusColor(1, active)
    let statline.=' %{noscrollbar#statusline(20,"-","=")}'
    let statline.=' %5l:%-3c'         " line and column
    let statline.=' [%L]'        " total lines
    return statline
endfunction

" }}}1 statusline ========================================
" {{{1 Maps ==============================================

" leaders
let mapleader=","
let maplocalleader=","

noremap Y y$

" very magic
nnoremap / /\v
vnoremap / /\v
" cnoremap %s/ %smagic/
" cnoremap >s/ >smagic/
" nnoremap :g/ :g/\v
" nnoremap :g// :g//

" buffer operations
" noremap QQ <ESC>:qall<CR>
noremap <leader>w :w<CR>
noremap <leader>q :call SmartClose()<CR>
inoremap <leader>w <ESC>:w<CR>
inoremap <leader>q <ESC>:call SmartClose()<CR>
noremap <leader>Q :wqall<CR>
inoremap <leader>Q <ESC>:wqall<CR>
noremap <leader>x :call LeaderX()<CR> <BAR> :nohls<CR>
nnoremap H :call BigH(0)<CR>
vnoremap H <ESC>:call BigH(1)<CR>
nnoremap L :call BigL(0)<CR>
vnoremap L <ESC>:call BigL(1)<CR>

" terminal
if has('nvim')
    tnoremap <leader><leader> <C-\><C-n>
    tnoremap <C-w>h <C-\><C-n><C-w>h
    tnoremap <C-w>j <C-\><C-n><C-w>j
    tnoremap <C-w>k <C-\><C-n><C-w>k
    tnoremap <C-w>l <C-\><C-n><C-w>l
    nnoremap <leader>tt :call TermJump()<CR>
    augroup TERMBUFFER
        autocmd!
        autocmd TermOpen * setlocal nospell | setlocal nocursorline
        " autocmd BufEnter term://* startinsert
    augroup END
endif

" Number increment/decrement
set <A-a>=a
set <A-x>=x
nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>
vnoremap <silent> <A-a> :s/\%V-\=\d\+/\=submatch(0)+1/g<CR>gv
vnoremap <silent> <A-x> :s/\%V-\=\d\+/\=submatch(0)-1/g<CR>gv

" prevent accidents (I never use these default commands)
noremap <C-a> <NOP>
" noremap q/ <NOP>
noremap K <NOP>
noremap Q <NOP>

" motions
noremap <expr>j (v:count ? 'j' : 'gj')
noremap <expr>k (v:count ? 'k' : 'gk')
noremap gj j
noremap gk k
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz
" noremap <TAB> %
" Tab is the same as C-i in terminal
" noremap <C-p> <C-i>
noremap - ;
noremap _ ,
noremap ]q :cnext<CR>
noremap [q :cprev<CR>
noremap ]l :lnext<CR>
noremap [l :lprevious<CR>
noremap <down> +
noremap <up> -

" formatting
vnoremap < <gv
vnoremap > >gv
nnoremap <leader>SS gg:%!git stripspace<CR><C-o>

" buffer selection
" map <LEFT> <C-^>
" map <RIGHT> :bn<CR>

" folds
" toggle current fold
noremap <silent> <space> za
set foldlevel=1000
" close all folds but current
noremap <F9> zM
" open all folds
noremap <F10> zR

" built-in calculator
let pi = 3.14159265359
let e  = 2.71828182846
vnoremap <leader>e ygvc<C-r>=<C-r>"<CR><ESC>

" resync syntax
noremap <F12> :redraw!<CR>:syntax sync fromstart<CR>

" too lazy to press shift
noremap ; :

" move search result to middle
nnoremap n nzzzMzv
nnoremap N NzzzMzv

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
" noremap <leader>z [s1z=<C-o>
" inoremap <leader>z <C-g>u<ESC>[s1z=`]a<C-g>u
noremap <leader>z [sh1z=<C-o>
inoremap <leader>z <C-g>u<ESC>[s1hz=`]a<C-g>u

map <F4> :call WritingToggle()<CR>

" information
nnoremap <leader>W m[ggVGg<C-g><Esc>`[

function! ListFKeys()
    let message = "F1 neomake! (project) \n" .
                \ "F2 neomake! clean \n" .
                \ "F3 (to be set in project vimrc) \n" .
                \ "F4 (to be set in project vimrc) \n" .
                \ "F5 toggle tag bar \n" .
                \ "F6 update taghl \n" .
                \ "F7 toggle gundo \n" .
                \ "F8 Wordy\n" .
                \ "F9 close all folds \n" .
                \ "F10 open all folds \n" .
                \ "F11 (open)\n" .
                \ "F12 re-sync syntax and fold \n"
    :12new
    silent put=message
    set nomodified
    set readonly
endfunction

map <leader>F :call ListFKeys()<CR>

" }}}1 Maps ==============================================
" {{{1 Plugin options ====================================

" {{{2 Vim-R-Plugin ======================================

" let R_term = "roxterm"
let R_term_cmd = "roxterm"
let R_in_buffer = 1
let R_hl_term = 1
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

" }}}2 Vim-R-Plugin ======================================
" {{{2 Gnuplot ===========================================
" }}}2 Gnuplot ===========================================
" {{{2 vim-commentary ====================================

imap <leader>cc <C-g>u<ESC><Plug>CommentaryLine
nmap <leader>cc <Plug>CommentaryLine
vmap <leader>cc <Plug>Commentary

" {{{3 vim-commentatry filetypes =========================

augroup VIMCOMMENTARY
    autocmd!
    autocmd FileType r setl commentstring=#\ %s
    autocmd FileType rmd setl commentstring=#\ %s
    autocmd FileType rnoweb setl commentstring=#\ %s
    autocmd FileType markdown setl commentstring=<!--\ %s\ -->
    autocmd FileType gnuplot setl commentstring=#\ %s
    autocmd FileType cpp setl commentstring=//\ %s
    autocmd FileType c setl commentstring=//\ %s
augroup END

" }}}3 vim-commentatry filetypes =========================

" }}}2 vim-commentary ====================================
" {{{2 vim-surround ======================================

let g:surround_no_mappings = 1

nmap ys <Plug>Ysurround
nmap Sd <Plug>Dsurround
nmap Sc <Plug>Csurround
nmap Sw ysiw
nmap SW ysiW
nmap Sa <Plug>Ysurround
nmap Sl <Plug>Yssurround
xmap Sa <Plug>VSurround

" }}}2 vim-surround ======================================
" {{{2 Tabularize ========================================

vnoremap <leader>& :Tabularize /&<CR>

" }}}2 Tabularize ========================================
" {{{2 undotree ==========================================

let g:undotree_WindowLayout = 3
let g:undotree_SplitWidth = 40
nmap <F6> :UndotreeToggle<CR>

" }}}2 undotree ==========================================
" {{{2 DragVisuals =======================================

vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()

" }}}2 DragVisuals =======================================
" {{{2 Pandoc ============================================

let g:pandoc#syntax#style#emphases = 0
let g:pandoc#syntax#conceal#use = 0
let g:pandoc#syntax#protect#codeblocks = 0
let g:pandoc_syntax_dont_use_conceal_for_rules =
    \ ['codeblock_start', 'codeblock_delim', 'dashes', 'hrule']

" }}}2 Pandoc ============================================
" {{{2 calendar.vim ======================================

let g:calendar_google_calendar = 1
let g:calendar_google_task = 1

function! Cal()
    :Calendar -view=week
endfunction
command! -nargs=0 Cal call Cal()

" }}}2 calendar.vim ======================================
" {{{2 TagBar ============================================

let g:tagbar_type_r = {
    \ 'ctagstype' : 'r',
    \ 'kinds'     : [
        \ 'f:Functions',
        \ 'g:GlobalVariables',
        \ 'v:FunctionVariables',
        \ ]
    \ }

let g:tagbar_map_togglefold = "<space>"

nmap <F5> :TagbarToggle<CR>

" }}}2 TagBar ============================================
" " {{{2 Rainbow ===========================================

" let g:rainbow_active = 1
" let g:rainbow_conf = {
"     \ 'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
"     \ 'ctermfgs': ['110', '187', '138', '180', '115', '131'],
"     \ 'operators': '_,_',
"     \ 'parentheses': [
"         \ 'start=/(/ end=/)/ fold',
"         \ 'start=/\[/ end=/\]/ fold',
"         \ 'start=/{/ end=/}/ fold'
"         \ ],
"     \ 'separately': {
"         \ '*': {},
"         \ 'tex': {
"             \ 'parentheses': [
"                 \ 'start=/(/ end=/)/', 'start=/\[/ end=/\]/'
"                 \],
"             \ },
"         \ 'vim': {
"             \ 'parentheses': [
"                 \ 'start=/(/ end=/)/',
"                 \ 'start=/\[/ end=/\]/',
"                 \ 'start=/{/ end=/}/ fold',
"                 \ 'start=/(/ end=/)/ containedin=vimFuncBody',
"                 \ 'start=/\[/ end=/\]/ containedin=vimFuncBody',
"                 \ 'start=/{/ end=/}/ fold containedin=vimFuncBody'
"                 \ ],
"             \ },
"         \ 'xml': {
"             \ 'parentheses': [
"                 \ 'start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'
"                 \ ],
"             \ },
"         \ 'xhtml': {
"             \ 'parentheses': [
"                 \ 'start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'
"                 \ ],
"             \ },
"         \ 'html': {
"             \ 'parentheses': [
"                 \ 'start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'
"                 \ ],
"             \ },
"         \ 'php': {
"             \ 'parentheses': [
"                 \ 'start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold', 'start=/(/ end=/)/ containedin=@htmlPreproc contains=@phpClTop', 'start=/\[/ end=/\]/ containedin=@htmlPreproc contains=@phpClTop', 'start=/{/ end=/}/ containedin=@htmlPreproc contains=@phpClTop'
"                 \ ],
"             \ },
"         \ 'css': 0,
"         \ 'rnoweb': 0,
"         \ 'rmd': 0,
"         \ 'mail': 0,
"         \ 'pandoc': 0
"         \ }
"     \}

" " }}}2 Rainbow ===========================================
" {{{2 vim-wordy =========================================

map <F8> :NextWordy<CR>

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

" }}}2 vim-wordy =========================================
" {{{2 ctrlp =============================================

" Use <C-f> to switch mode

let g:ctrlp_map = '<leader>f'
nnoremap <leader>b :CtrlPBuffer<CR>
let g:ctrlp_extensions = ['tag']
let g:ctrlp_working_path_mode = 'rw'
let g:ctrlp_show_hidden = 1
let g:ctrlp_max_depth = 10
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_prompt_mappings = {
    \ 'CreateNewFile()': ['<F2>']
    \ }

hi CtrlPMode1 ctermbg=238 ctermfg=180


" }}}2 ctrlp =============================================
" {{{2 UltiSnips =========================================

let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"

let g:UltiSnipsUsePythonVersion=2

" }}}2 UltiSnips =========================================
" {{{2 YouCompleteMe =====================================

let g:ycm_filetype_blacklist = {
    \ 'tagbar' : 1,
    \ 'qf' : 1,
    \ 'notes' : 1,
    \ 'unite' : 1,
    \ 'vimwiki' : 1,
    \ 'tex' : 1,
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

" }}}2 YouCompleteMe =====================================
" {{{2 TagHighlight ======================================

if ! exists('g:TagHighlightSettings')
    let g:TagHighlightSettings = {}
endif
let g:TagHighlightSettings['ForcedPythonVariant'] = 'if_pyth'

hi link CTagsDefinedName function

map <F7> :UpdateTypesFile<CR>

" }}}2 TagHighlight ======================================
" {{{2 neomake ===========================================

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

    autocmd BufWritePost *.R Neomake
    autocmd BufReadPost *.R Neomake
    autocmd BufWinEnter *.R sign define dummy
    autocmd BufWinEnter *.R execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
augroup END

map <F1> :Neomake! make<CR>
map <F2> :Neomake! clean<CR>
" set <F3> in project vimrc
" map <F4> :Neomake<CR>

let g:neomake_error_sign = {
    \ 'text': '>',
    \ 'texthl': 'ErrorMsg',
    \ }
let g:neomake_warning_sign = {
    \ 'text': '>',
    \ 'texthl': 'WarningMsg',
    \ }

" {{{3 make ==============================================

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

" }}}3 make ==============================================
" {{{3 python ============================================

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

" }}}3 python ============================================
" {{{3 cpp ===============================================

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

" }}}3 cpp ===============================================
" {{{3 r =================================================

let g:neomake_r_lintr_maker = {
    \ 'exe': 'lintr',
    \ 'args': [],
    \ 'errorformat':
    \ '%W%f:%l:%c: style: %m,' .
    \ '%W%f:%l:%c: warning: %m,' .
    \ '%E%f:%l:%c: error: %m',
    \ }

let g:neomake_r_enabled_makers = ['lintr']

" }}}3 r =================================================

" }}}2 neomake ===========================================
" {{{2 vim-cpp-enhanced-highlight "

let g:cpp_class_scope_highlight = 1

" 2}}} vim-cpp-enhanced-highlight "

" }}}1 Plugin options ====================================

" let rmd_syn_hl_chunk=1
" vim:fdm=marker:foldlevel=0
