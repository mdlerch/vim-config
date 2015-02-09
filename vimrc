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
Plug 'junegunn/goyo.vim'
Plug 'itchyny/calendar.vim'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree'
Plug 'reedes/vim-wordy'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

" file tools
Plug 'kien/ctrlp.vim'
Plug 'rking/ag.vim'

" filetype and syntax
Plug 'git@github.com:mdlerch/vim-gnuplot.git'
Plug 'git@github.com:mdlerch/vim-julia.git'
Plug 'git@github.com:mdlerch/vim-mc-stan.git'
Plug 'git@github.com:mdlerch/vim-pandoc-syntax'
Plug 'git@github.com:mdlerch/vim-pandoc'
Plug 'git@github.com:mdlerch/Nvim-R.git'
Plug 'abudden/taghighlight-automirror'
Plug 'justinmk/vim-syntax-extra'
Plug 'vim-scripts/gnuplot.vim'

" colorschemes
Plug 'git@github.com:mdlerch/vim-tungsten.git'
Plug 'git@github.com:mdlerch/rainbow'
Plug 'altercation/vim-colors-solarized'
Plug 'endel/vim-github-colorscheme'
Plug 'gerw/vim-HiLinkTrace'
Plug 'junegunn/seoul256.vim'
Plug 'romainl/Apprentice'

call plug#end()

" }}}1 vim-plug  ==========================================
" {{{1 Functions =========================================

" {{{2 Smart close =======================================

" Save active buffer.
" If only one window, try to quit vim.
" If multiple windows close the current window.
function! SmartClose()
    " If file is non-mondifiable or readonly, etc, quit
    if &readonly || !&modifiable || expand('%:t:r') =~ "test" || &ft =~ "rdoc"
        exe ":q!"
        return 0
    endif

    " One window: write this buffer, qall
    if winnr('$') == 1
        exe ":w"
        exe ":qall"
    " multiple windows: write this buffer, close
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
" {{{2 location/qf toggling ==============================

function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

" }}}2 location/qf toggling ==============================
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
    exe 'norm! mX'
    pclose
    if &modifiable && !&readonly
        let _s=@/
        s/\s\+$//e
        let @/=_s
    endif
    exe 'norm! `X'
endfunction

" }}}2 Leader x, clear things ============================

" }}}1 Functions =========================================
" {{{1 Options/settings ==================================

set nocompatible
syntax enable
filetype plugin indent on
set backspace=indent,eol,start

" starting position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
au BufReadPost GHI* :1
au BufReadPost COMMIT* :1

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
set listchars=tab:▸\ ,eol:¬,trail:·
set list
set splitbelow
set splitright
set scrolloff=4
set completeopt+=menuone,longest
set completeopt+=preview
set spell
if &term =~ "^screen"
    set ttymouse=xterm2
endif
set breakindent
set linebreak
set breakat-=-
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
set wildignore+=*.out,*.aux,*.toc,*/undodir/*
" set wildignore+=*.jpg,*.png,*.pdf,*.ps,*.eps

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
highlight Comment cterm=italic gui=italic
hi def link gitcommitOverflow Error

if g:colors_name=="zenburn"
    highlight SpecialKey ctermfg=238
endif

highlight ExtraWhitespace ctermfg=red guifg=red
match ExtraWhitespace /\s\+$/
" in insert mode do not highlight in current line
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

function! UnmatchWhite()
    highlight ExtraWhitespace ctermfg=None guifg=None
endfunction

autocmd FileType rbrowser call UnmatchWhite()

highlight MatchParen cterm=NONE

" statusline
hi User1 ctermbg=234 ctermfg=110
hi User2 ctermbg=238 ctermfg=180
hi User3 ctermbg=234 ctermfg=196
set laststatus=2
set statusline=
set statusline+=%#User1#
set statusline+=%f\           " relative filename
set statusline+=%#User3#
set statusline+=%R\           " readonly
set statusline+=%m\           " modified
set statusline+=%#User1#
set statusline+=%=
set statusline+=%#User2#
set statusline+=\ %Y\         " filetype
set statusline+=%#User1#
set statusline+=\ %{noscrollbar#statusline(20,'-','=')}
set statusline+=\ %5l:%-3c         " line and column
set statusline+=\ [%L]        " total lines

" }}}1 Color and appearance ==============================
" {{{1 Maps ==============================================

" leaders
let mapleader=","
let maplocalleader=","

" buffer operations
" noremap QQ <ESC>:qall<CR>
noremap <leader>w :w<CR>
noremap <leader>q :call SmartClose()<CR>
inoremap <leader>w <ESC>:w<CR>
inoremap <leader>q <ESC>:call SmartClose()<CR>
noremap <leader>Q :wqall<CR>
inoremap <leader>Q <ESC>:wqall<CR>
noremap <leader>vc :call ToggleList("Location List", "l")<CR>
noremap <leader>cv :call ToggleList("Quickfix List", "c")<CR>

" Number increment/decrement
set <A-a>=a
set <A-x>=x
nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>
vnoremap <silent> <A-a> :s/\%V-\=\d\+/\=submatch(0)+1/g<CR>gv
vnoremap <silent> <A-x> :s/\%V-\=\d\+/\=submatch(0)-1/g<CR>gv

" prevent accidents (I never use these default commands)
noremap <C-a> <NOP>
noremap q/ <NOP>
noremap K <NOP>
noremap Q <NOP>

" motions
noremap <expr>j (v:count ? 'j' : 'gj')
noremap <expr>k (v:count ? 'k' : 'gk')
noremap gj j
noremap gk k
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz
nnoremap H :call BigH(0)<CR>
vnoremap H <ESC>:call BigH(1)<CR>
nnoremap L :call BigL(0)<CR>
vnoremap L <ESC>:call BigL(1)<CR>
noremap <TAB> %
" Tab is the same as C-i in terminal
noremap <C-p> <C-i>
noremap - ;
noremap _ ,
noremap ]q :cnext<CR>
noremap [q :cprev<CR>
noremap ]v :lnext<CR>
noremap [v :lprevious<CR>

" formatting
vnoremap < <gv
vnoremap > >gv
nnoremap <leader>SS gg:%!git stripspace<CR><C-o>

" buffer selection
map <LEFT> <C-^>
map <RIGHT> :bn<CR>

" folds
" toggle current fold
noremap <silent> <space> za
set foldlevel=1000
" close all folds
noremap <F9> zM
" open all folds
noremap <F10> zR

" built-in calculator
let pi = 3.14159265359
let e  = 2.71828182846
vnoremap <leader>e ygvc<C-r>=<C-r>"<CR><ESC>

" resync syntax
noremap <F12> :redraw!<CR>:syntax sync fromstart<CR>:set foldmethod=marker<CR>

" close scratch, remove hlsearch, remove trailing whitespace
noremap <silent> <leader>x :nohls <BAR> :call LeaderX()<CR>

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
noremap <leader>z [s1z=<C-o>
inoremap <leader>z <C-g>u<ESC>[s1z=`]a<C-g>u


" information
nnoremap <leader>W m[ggVGg<C-g><Esc>`[

function! ListFKeys()
    let message = "F1 neomake! (project) \n" .
                \ "F2 neomake! clean \n" .
                \ "F3 (to be set in project vimrc) \n" .
                \ "F4 neomake (file) \n" .
                \ "F5 toggle tag bar \n" .
                \ "F6 update taghl \n" .
                \ "F7 toggle gundo \n" .
                \ "F8 Wordy\n" .
                \ "F9 close all folds \n" .
                \ "F10 open all folds \n" .
                \ "F11 (open) .
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

let R_term = "urxvt"
" let R_term_cmd = "urxvtc"
" let R_in_buffer = 0
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

" }}}2 Vim-R-Plugin ======================================
" {{{2 Gnuplot ===========================================
" }}}2 Gnuplot ===========================================
" {{{2 vim-commentary ====================================

imap <leader>cc <C-g>u<ESC><Plug>CommentaryLine
nmap <leader>cc <Plug>CommentaryLine
vmap <leader>cc <Plug>Commentary

" {{{3 vim-commentatry filetypes =========================

autocmd FileType r setl commentstring=#\ %s
autocmd FileType rmd setl commentstring=#\ %s
autocmd FileType rnoweb setl commentstring=#\ %s
autocmd FileType pandoc setl commentstring=<!--\ %s\ -->
autocmd FileType gnuplot setl commentstring=#\ %s
autocmd FileType cpp setl commentstring=//\ %s
autocmd FileType c setl commentstring=//\ %s

" }}}3 vim-commentatry filetypes =========================

" }}}2 vim-commentary ====================================
" {{{2 vim-surround ======================================

let g:surround_no_mappings = 1

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

let g:pandoc#modules#enabled = ["bibliographies", "completion"]

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
" {{{2 goyo ==============================================

let g:goyo_width = 80
let g:goyo_margin_top = 0
let g:goyo_margin_bottom = 0
let g:goyo_linenr = 1
let g:goyo_status = 1

function! s:goyo_enter()
    let g:old_tw = &tw
    set tw=0
    set wm=0
    set laststatus=2
endfunction

function! s:goyo_leave()
    let cmd = "set tw=" . g:old_tw
    exe cmd
    set laststatus=2
endfunction

autocmd! User GoyoEnter
autocmd! User GoyoLeave
autocmd User GoyoEnter nested call <SID>goyo_enter()
autocmd User GoyoLeave nested call <SID>goyo_leave()

" }}}2 goyo ==============================================
" {{{2 Rainbow ===========================================

let g:rainbow_active = 1
let g:rainbow_conf = {
    \ 'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
    \ 'ctermfgs': ['110', '187', '138', '180', '115', '131'],
    \ 'operators': '_,_',
    \ 'parentheses': [
        \ 'start=/(/ end=/)/ fold',
        \ 'start=/\[/ end=/\]/ fold',
        \ 'start=/{/ end=/}/ fold'
        \ ],
    \ 'separately': {
        \ '*': {},
        \ 'tex': {
            \ 'parentheses': [
                \ 'start=/(/ end=/)/', 'start=/\[/ end=/\]/'
                \],
            \ },
        \ 'vim': {
            \ 'parentheses': [
                \ 'start=/(/ end=/)/',
                \ 'start=/\[/ end=/\]/',
                \ 'start=/{/ end=/}/ fold',
                \ 'start=/(/ end=/)/ containedin=vimFuncBody',
                \ 'start=/\[/ end=/\]/ containedin=vimFuncBody',
                \ 'start=/{/ end=/}/ fold containedin=vimFuncBody'
                \ ],
            \ },
        \ 'xml': {
            \ 'parentheses': [
                \ 'start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'
                \ ],
            \ },
        \ 'xhtml': {
            \ 'parentheses': [
                \ 'start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'
                \ ],
            \ },
        \ 'html': {
            \ 'parentheses': [
                \ 'start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'
                \ ],
            \ },
        \ 'php': {
            \ 'parentheses': [
                \ 'start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold', 'start=/(/ end=/)/ containedin=@htmlPreproc contains=@phpClTop', 'start=/\[/ end=/\]/ containedin=@htmlPreproc contains=@phpClTop', 'start=/{/ end=/}/ containedin=@htmlPreproc contains=@phpClTop'
                \ ],
            \ },
        \ 'css': 0,
        \ 'rnoweb': 0,
        \ 'rmd': 0,
        \ 'mail': 0,
        \ 'pandoc': 0
        \ }
    \}

" }}}2 Rainbow ===========================================
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

let g:ycm_global_ycm_extra_conf = '~/.vim/default_ycm_conf.py'
let g:ycm_show_diagnostics_ui = 0
let g:ycm_cache_omnifunc = 0
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_key_list_select_completion = ['<TAB>', '<DOWN>']
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_extra_conf_globlist = ['./*']
let g:ycm_autoclose_preview_window_after_completion = 1

" }}}2 YouCompleteMe =====================================
" {{{2 TagHighlight ======================================

map <F7> :UpdateTypesFile<CR>

" }}}2 TagHighlight ======================================
" {{{2 neomake ===========================================

map <F1> :Neomake!<CR>
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
    \ 'args': [],
    \ 'errorformat': '%f:%l%c: %m',
    \ }

let g:neomake_clean_maker = {
    \ 'exe': 'make',
    \ 'args': ['clean'],
    \ 'errorformat': '%f:%l%c: %m',
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

autocmd BufWritePost *.py Neomake
autocmd BufReadPost *.py Neomake

autocmd BufReadPost *.py sign define dummy
autocmd BufReadPost *.py execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

" }}}3 python ============================================
" {{{3 cpp ===============================================

let s:RcppArmadilloInclude =
    \ "/home/mike/R/x86_64-unknown-linux-gnu-library/3.1/RcppArmadillo/include/"
let s:RcppInclude =
    \ "/home/mike/R/x86_64-unknown-linux-gnu-library/3.1/Rcpp/include/"
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

autocmd BufWritePost *.cpp Neomake
autocmd BufReadPost *.cpp Neomake

autocmd BufReadPost *.cpp sign define dummy
autocmd BufReadPost *.cpp execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

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

autocmd BufWritePost *.R Neomake
autocmd BufReadPost *.R Neomake

autocmd BufReadPost *.R sign define dummy
autocmd BufReadPost *.R execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

" }}}3 r =================================================

" }}}2 neomake ===========================================

" }}}1 Plugin options ====================================

" let rmd_syn_hl_chunk=1
" vim:fdm=marker:foldlevel=0
