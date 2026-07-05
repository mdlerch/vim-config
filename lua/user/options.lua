--------------------------------------------------------------------------------
-- Options Configuration Module
-- Purpose: Holds all global settings, editor options, and global variables.
-- What goes here:
--  * vim.opt.* (tabs, appearance, searching, splits, timeouts, folds, etc.)
--  * vim.g.* (global plugin variables like Nvim-R setups)
--------------------------------------------------------------------------------
local opt = vim.opt


-- General options
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
opt.cinoptions:append("(0")
opt.cpoptions:append("J")
opt.formatprg = "par -w80"

-- Appearance
opt.termguicolors = true
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
opt.breakat:remove("-")
opt.breakat:append("@")

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

-- Wildmenu
opt.wildmode = { "longest", "list", "full" }
opt.wildignore:append({ "*.out", "*.aux", "*.toc", "*/undodir/*", "*.o", "*.log", "tags" })

-- Session
opt.sessionoptions:append({ "globals" })

-- Tags
opt.tags = "./tags;"

-- Folds
opt.foldlevel = 1

-- Color and appearance
opt.cursorline = true
opt.laststatus = 2

-- Nvim-R Plugin Configuration
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
