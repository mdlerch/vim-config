local M = {}

-- {{{1 Functions

-- Smart close
function M.smart_close()
    if vim.bo.readonly or not vim.bo.modifiable or vim.fn.expand('%:t:r'):match("test") or vim.bo.filetype == "rdoc" then
        if #vim.fn.filter(vim.fn.range(1, vim.fn.bufnr('$')), 'buflisted(v:val)') <= 1 then
            vim.cmd("quit")
        else
            vim.cmd("bdelete")
        end
        return
    end

    if vim.fn.winnr('$') == 1 then
        vim.cmd("write")
        if #vim.fn.filter(vim.fn.range(1, vim.fn.bufnr('$')), 'buflisted(v:val)') > 1 then
            vim.cmd("bdelete")
        else
            vim.cmd("quit")
        end
    else
        vim.cmd("write")
        vim.cmd("close")
    end
end

-- convert endlines from dos to unix
function M.dos2unix()
    vim.cmd([[%s/\r//g]])
end

-- place output of vim command into new split
function M.grab(cmd)
    local message = vim.api.nvim_exec(cmd, true)
    vim.cmd("10new")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(message, "\n"))
    vim.bo.modified = false
    vim.bo.readonly = true
end

-- Launchers
local function jobstart(cmd)
    vim.fn.jobstart(cmd)
end

function M.launch_pdf(args)
    local pdfviewer = "zathura"
    local file = args ~= "" and args or (vim.fn.expand("%:r") .. ".pdf")
    jobstart(pdfviewer .. " " .. file .. " 2> /dev/null")
end

function M.launch_png(args)
    local pngviewer = "gpicview"
    local file = args ~= "" and args or (vim.fn.expand("%:r") .. ".png")
    jobstart(pngviewer .. " " .. file .. " 2> /dev/null")
end

function M.launch_html(args)
    local htmlviewer = "chromium"
    local file = args ~= "" and args or (vim.fn.expand("%:r") .. ".html")
    jobstart(htmlviewer .. " " .. file)
end

function M.fuzzy_launch(launcher, ext)
    local sourcer = 'find -iname "*.' .. ext .. '"'
    local sinker = launcher
    vim.fn['fzf#run']({
        source = sourcer,
        sink = sinker,
        down = '40%',
        options = '--color dark,pointer:110,hl+:110,bg+:234'
    })
end

-- Smart motion to beginning of line
function M.big_h(vis)
    local oldcol = vim.fn.col('.')
    vim.cmd('norm! g^')
    local newcol = vim.fn.col('.')
    if newcol == oldcol then
        vim.cmd('norm! g0')
    end
    if vis == 1 then
        vim.cmd('norm! m>`>gv')
    end
end

-- Smart motion to end of the line
function M.big_l(vis)
    local oldcol = vim.fn.col('.')
    vim.cmd('norm! g$')
    if vim.fn.getline('.'):sub(vim.fn.col('.'), vim.fn.col('.')):match('%s') then
        vim.cmd('norm! ge')
    end
    local newcol = vim.fn.col('.')
    if newcol == oldcol then
        vim.cmd('norm! g$')
    end
    if vis == 1 then
        vim.cmd('norm! m>`>gv')
    end
end

-- remove trailing whitespace on current line
function M.kill_white_space()
    if vim.bo.modifiable and not vim.bo.readonly then
        local save_query = vim.fn.getreg('/')
        vim.cmd([[s/\s\+$//e]])
        vim.fn.setreg('/', save_query)
    end
end

-- If a buffer named term:// is in a window, jump to it
function M.term_jump()
    for winnum = 1, vim.fn.winnr('$') do
        if vim.fn.bufname(vim.fn.winbufnr(winnum)):match("term://") then
            vim.cmd(winnum .. "wincmd w")
            return
        end
    end
    for bufnum = 1, vim.fn.bufnr('$') do
        if vim.fn.bufname(bufnum):match("term://") then
            vim.cmd("split")
            vim.cmd("buffer " .. vim.fn.bufname(bufnum))
            return
        end
    end
end

-- Toggle maximize a window
local toggle_max_prev = ""
function M.toggle_max()
    if vim.fn.winnr('$') == 1 then
        if vim.fn.tabpagenr('$') == 1 then
            print("Only tab remaining")
            return
        elseif toggle_max_prev == "" then
            print("Not a maximized tab")
        else
            vim.cmd("close")
            vim.cmd("tabn " .. toggle_max_prev)
            toggle_max_prev = ""
        end
    else
        toggle_max_prev = vim.fn.tabpagenr()
        vim.cmd("tab sp")
    end
end

-- WritingToggle (moved from plugin/writing.vim)
local writing_on = false
local oldtw = 80
function M.writing_toggle()
    if not writing_on then
        oldtw = vim.bo.textwidth
        local mainwindow = vim.fn.winnr()
        local mycolumns = vim.bo.textwidth + vim.wo.numberwidth + vim.wo.foldcolumn
        vim.cmd("vnew padding_test")
        vim.bo.readonly = true
        vim.cmd(mainwindow .. "wincmd w")
        vim.bo.textwidth = 0
        vim.cmd("vertical resize " .. mycolumns)
        writing_on = true
    else
        vim.bo.textwidth = oldtw
        vim.cmd("bdelete padding_test")
        writing_on = false
    end
end

-- }}} Functions
-- {{{1 Options/settings

local opt = vim.opt

opt.backspace = { "indent", "eol", "start" }
opt.hidden = true
opt.mouse = "ni"
opt.nrformats = { "octal", "hex", "alpha" }
opt.exrc = true
opt.secure = true

-- Tabs
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 0
opt.shiftwidth = 4
opt.smarttab = true

-- Text formatting
opt.textwidth = 80
opt.formatoptions = "clt"
vim.opt.cinoptions:append("(0")
vim.opt.cpoptions:append("J")
-- formatprg handled in autocmd or simple assignment
opt.formatprg = "par -w80"

-- Appearance
opt.showcmd = true
opt.showmode = true
opt.number = true
opt.relativenumber = true
opt.listchars = { tab = "▸ ", trail = "·" }
opt.list = true
opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 4
opt.completeopt = { "menuone" }
opt.spell = true
opt.breakindent = true
opt.linebreak = true
vim.opt.breakat:remove("-")
vim.opt.breakat:append("@")

-- Files
opt.undodir = vim.fn.expand("~/.cache/nvim/undodir")
opt.undofile = true
opt.swapfile = true
opt.shada:append("n$HOME/.cache/nvim/shada")
vim.g.netrw_home = vim.fn.expand("$HOME") .. "/.cache/"

-- Searching
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Timeouts
opt.timeoutlen = 700
opt.ttimeoutlen = 10
opt.lazyredraw = false

-- Wildmenu
opt.wildmode = { "longest", "list", "full" }
opt.wildignore:append({ "*.out", "*.aux", "*.toc", "*/undodir/*", "*.o", "*.log", "tags" })

-- Session
opt.sessionoptions:append({ "globals" })

-- }}} Options/settings
-- {{{1 Maps

local keymap = vim.keymap.set

keymap("n", "Y", "y$")

-- Toggle comment
keymap("n", "<leader>cc", "gcc", { remap = true, desc = "Toggle comment" })
keymap("v", "<leader>cc", "gc", { remap = true, desc = "Toggle comment" })

-- very magic
keymap("n", "/", "/\\v")
keymap("v", "/", "/\\v")

-- buffer operations
keymap("n", "<leader>w", ":w<CR>")
keymap("n", "<leader>q", M.smart_close)
keymap("i", "<leader>w", "<ESC>:w<CR>")
keymap("i", "<leader>q", "<ESC>:lua require('core').smart_close()<CR>")
keymap("n", "<leader>Q", ":wqall<CR>")
keymap("i", "<leader>Q", "<ESC>:wqall<CR>")
keymap("n", "<leader>x", ":pclose | nohls<CR>")

-- terminal
keymap("t", "<leader><leader>", [[<C-\><C-n>]])
keymap("t", "<C-w>h", [[<C-\><C-n><C-w>h]])
keymap("t", "<C-w>j", [[<C-\><C-n><C-w>j]])
keymap("t", "<C-w>k", [[<C-\><C-n><C-w>k]])
keymap("t", "<C-w>l", [[<C-\><C-n><C-w>l]])
keymap("n", "<leader>tt", M.term_jump)
keymap("t", "gt", [[<C-\><C-n>gt]])

-- Number increment/decrement
keymap("n", "<A-a>", "<C-a>")
keymap("n", "<A-x>", "<C-x>")
keymap("v", "<A-a>", ":s/\\%V-\\=\\d\\+/\\=submatch(0)+1/g<CR>gv", { silent = true })
keymap("v", "<A-x>", ":s/\\%V-\\=\\d\\+/\\=submatch(0)-1/g<CR>gv", { silent = true })

-- prevent accidents
keymap("", "<C-a>", "<NOP>")
keymap("n", "K", "<NOP>")
keymap("n", "Q", "<NOP>")
keymap("", ";", ":")

-- motions
keymap("", "j", "v:count ? 'j' : 'gj'", { expr = true })
keymap("", "k", "v:count ? 'k' : 'gk'", { expr = true })
keymap("", "gj", "j")
keymap("", "gk", "k")
keymap("", "<C-d>", "<C-d>zz")
keymap("", "<C-u>", "<C-u>zz")
keymap("n", "-", ";")
keymap("n", "_", ",")
keymap("n", "]q", ":cnext<CR>")
keymap("n", "[q", ":cprev<CR>")
keymap("n", "]l", ":lnext<CR>")
keymap("n", "[l", ":lprevious<CR>")
keymap("n", "<down>", "+")
keymap("n", "<up>", "-")
keymap("n", "H", function() M.big_h(0) end)
keymap("x", "H", function() M.big_h(1) end)
keymap("n", "L", function() M.big_l(0) end)
keymap("x", "L", function() M.big_l(1) end)
keymap("n", "n", "nzzzxzv")
keymap("n", "N", "Nzzzxzv")

-- formatting
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")
keymap("n", "<leader>SS", "gg:%!git stripspace<CR><C-o>")

-- folds
keymap("", "<space>", "za", { silent = true })
opt.foldlevel = 1
keymap("n", "<F9>", "zm")
keymap("n", "<F10>", "zr")
keymap("n", "<F11>", "zMzv")
keymap("n", "]z", "zj")

-- built-in calculator
keymap("v", "<leader>e", 'ygvc<C-r>=<C-r>"<CR><ESC>')

-- resync syntax
keymap("n", "<F12>", ":redraw! | syntax sync fromstart<CR>")

-- apply last command to all lines in visual selection
keymap("v", ".", ":normal . <CR>")

-- shorthand functions
vim.cmd([[
cabbr setwd cd %:h<CR>:pwd<CR>
cabbr d2u lua require('core').dos2unix()
]])

-- too lazy for esc
keymap("i", "<C-w>", "<ESC><C-w>")
keymap("i", "<leader><leader>", "<C-[>")
keymap("v", "<leader><leader>", "<C-[>")
keymap("n", "<leader><leader>", "<C-[>")
keymap("c", "<leader><leader>", "<C-c>")

-- tags
keymap("n", "<leader>ts", "<C-w><C-]>")
keymap("n", "<leader>tj", "<C-]>")
keymap("n", "<leader>tr", ":!ctags -R<CR>")
opt.tags = "./tags;"

-- Quick spell fix
keymap("n", "<leader>z", "[s1z=<C-o>")
keymap("i", "<leader>z", "<C-g>u<ESC>[s1z=`]a<C-g>u")

-- Custom maps
keymap("n", "<F5>", M.writing_toggle)
keymap("n", "gs", M.kill_white_space)
keymap("n", "<C-w>m", M.toggle_max)

-- information
keymap("n", "<leader>W", "m[ggVGg<C-g><Esc>`[")

function M.list_f_keys()
    local message = [[
F1 Built-in make (all) 
F2 Built-in clean 
F3 set in project? 
F4 Built-in diff 
F5 WritingToggle 
F6 NONE 
F7 NONE
F8 NONE
F9 close all folds 
F10 open all folds 
F11 redo folding 
F12 re-sync syntax 
]]
    vim.cmd("12new")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(message, "\n"))
    vim.bo.modified = false
    vim.bo.readonly = true
end

keymap("n", "<leader>F", M.list_f_keys)

-- }}} Maps
-- {{{1 Plugin Config

-- Nvim-R
vim.g.R_in_buffer = 1
vim.g.R_hl_term = 1
vim.g.R_setwidth = 1
vim.g.R_assign = 0
vim.g.R_objbr_place = "script,right"
vim.g.R_tmux_ob = 1
vim.g.R_nvimpager = "horizontal"
vim.g.R_args = {'--no-save', ' --no-restore-data'}
vim.g.R_notmuxconf = 1
vim.g.R_rconsole_height = 15
vim.g.R_tmux_title = "automatic"
vim.g.R_listmethods = 1
vim.g.R_latexcmd = "texi2pdf"
vim.g.R_ca_ck = 1
vim.g.R_pdfviewer = "zathura"
vim.g.R_openpdf = 0
vim.g.R_openhtml = 0
vim.g.R_insert_mode_cmds = 0
vim.g.R_allnames = 1
vim.g.R_rmhidden = 1
vim.g.R_restart = 1
vim.g.R_show_args = 1
vim.g.R_nvim_wd = 1
vim.g.R_user_maps_only = 1
vim.g.R_tmpdir = vim.fn.expand("~/.cache/Nvim-R")
vim.g.R_compldir = vim.fn.expand("~/.cache/Nvim-R")
vim.g.R_synctex = 0
vim.g.rout_follow_colorscheme = 1
vim.g.R_args_in_stline = 0

-- }}} Plugin Config
-- {{{1 Color and appearance

opt.cursorline = true
vim.cmd("colorscheme tungsten")

-- Extra whitespace
vim.api.nvim_set_hl(0, "ExtraWhitespace", { fg = "red" })
vim.fn.matchadd("ExtraWhitespace", [[\s\+$]])

local whitespace_group = vim.api.nvim_create_augroup("WHITESPACE", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
    group = whitespace_group,
    pattern = "*",
    command = [[match ExtraWhitespace /\s\+\%#\@<!$/]],
})
vim.api.nvim_create_autocmd("InsertLeave", {
    group = whitespace_group,
    pattern = "*",
    command = [[match ExtraWhitespace /\s\+$/]],
})

vim.api.nvim_set_hl(0, "MatchParen", { underline = false, bold = false })

-- }}} Color and appearance
-- {{{1 Statusline

opt.laststatus = 2

local status_group = vim.api.nvim_create_augroup("status", { clear = true })

-- User colors for statusline
vim.api.nvim_set_hl(0, "User1", { bg = "#1c1c1c", fg = "#87afd7" })
vim.api.nvim_set_hl(0, "User2", { bg = "#444444", fg = "#dfaf87" })
vim.api.nvim_set_hl(0, "User3", { bg = "#1c1c1c", fg = "#ff0000" })
vim.api.nvim_set_hl(0, "User4", { bg = "#444444", fg = "#87afd7" })
vim.api.nvim_set_hl(0, "User5", { bg = "#444444", fg = "#87afd7" })
vim.api.nvim_set_hl(0, "User6", { bg = "#444444", fg = "#87afd7" })

function M.set_statusline(winnum)
    local unactive = not (winnum == vim.fn.winnr())

    local function status_color(num, is_unactive)
        local shift = 0
        if is_unactive then
            shift = 3
        end
        return "%" .. (num + shift) .. "*"
    end

    local thefilename = vim.fn.expand('%')
    local statline = ""

    if vim.api.nvim_win_get_width(0) > 100 then
        statline = statline .. status_color(2, unactive)
        -- Fugitive statusline removed as requested
    end

    statline = statline .. status_color(1, unactive)
    statline = statline .. ' '
    if #thefilename < 30 then
        statline = statline .. '%f '
    else
        statline = statline .. '///%t '
    end

    statline = statline .. status_color(3, unactive)
    statline = statline .. '%R %m '
    statline = statline .. status_color(1, unactive)
    statline = statline .. '%='
    
    if vim.api.nvim_win_get_width(0) > 100 then
        statline = statline .. (vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding)
    end
    
    statline = statline .. ' ' .. status_color(2, unactive) .. ' %Y '
    statline = statline .. status_color(1, unactive)
    
    if vim.api.nvim_win_get_width(0) > 100 then
        -- noscrollbar fallback
        statline = statline .. ' %{noscrollbar#statusline(20,"-","=")}'
    end
    
    statline = statline .. ' %5l:%-3c [%L]'
    return statline
end

vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
    group = status_group,
    callback = function()
        for winnum = 1, vim.fn.winnr('$') do
            vim.fn.setwinvar(winnum, '&statusline', '%!v:lua.require("core").set_statusline(' .. winnum .. ')')
        end
    end,
})

-- }}} Statusline

-- autocmds for start position
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local line = vim.fn.line("'\"")
        if line > 1 and line <= vim.fn.line("$") then
            vim.cmd([[normal! g`"]])
        end
    end,
})

return M
