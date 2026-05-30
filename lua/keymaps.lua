--------------------------------------------------------------------------------
-- Keymaps Configuration Module
-- Purpose: Defines all personal keyboard mappings and shortcuts.
-- What goes here:
--  * vim.keymap.set mappings for Normal, Visual, Insert, and Terminal modes.
--  * Command-line abbreviations (cabbr).
--  * Invocation links calling helper functions in `lua/utils.lua`.
--------------------------------------------------------------------------------
local keymap = vim.keymap.set
local utils = require("utils")

-- General maps
keymap("n", "Y", "y$")

-- Toggle comment (Neovim 0.10+ native commenter)
keymap("n", "<leader>cc", "gcc", { remap = true, desc = "Toggle comment" })
keymap("v", "<leader>cc", "gc", { remap = true, desc = "Toggle comment" })

-- very magic searching
keymap("n", "/", "/\\v")
keymap("v", "/", "/\\v")

-- buffer operations
keymap("n", "<leader>w", ":w<CR>")
keymap("n", "<leader>q", utils.smart_close)
keymap("i", "<leader>w", "<ESC>:w<CR>")
keymap("i", "<leader>q", "<ESC>:lua require('utils').smart_close()<CR>")
keymap("n", "<leader>Q", ":wqall<CR>")
keymap("i", "<leader>Q", "<ESC>:wqall<CR>")
keymap("n", "<leader>x", ":pclose | nohls<CR>")

-- terminal mappings
keymap("t", "<leader><leader>", [[<C-\><C-n>]])
keymap("t", "<C-w>h", [[<C-\><C-n><C-w>h]])
keymap("t", "<C-w>j", [[<C-\><C-n><C-w>j]])
keymap("t", "<C-w>k", [[<C-\><C-n><C-w>k]])
keymap("t", "<C-w>l", [[<C-\><C-n><C-w>l]])
keymap("n", "<leader>tt", utils.term_jump)
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

-- visual movements
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

-- smart motions
keymap("n", "H", function() utils.big_h(0) end)
keymap("x", "H", function() utils.big_h(1) end)
keymap("n", "L", function() utils.big_l(0) end)
keymap("x", "L", function() utils.big_l(1) end)
keymap("n", "n", "nzzzxzv")
keymap("n", "N", "Nzzzxzv")

-- visual formatting indentation
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")
keymap("n", "<leader>SS", "gg:%!git stripspace<CR><C-o>")

-- folds
keymap("", "<space>", "za", { silent = true })
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

-- shorthand commands
vim.cmd([[
cabbr setwd cd %:h<CR>:pwd<CR>
cabbr d2u lua require('utils').dos2unix()
]])

-- Grab command output into an editable, searchable split buffer
vim.api.nvim_create_user_command("Grab", function(opts)
  utils.grab(opts.args)
end, { nargs = 1 })


-- escape shorthand
keymap("i", "<C-w>", "<ESC><C-w>")
keymap("i", "<leader><leader>", "<C-[>")
keymap("v", "<leader><leader>", "<C-[>")
keymap("n", "<leader><leader>", "<C-[>")
keymap("c", "<leader><leader>", "<C-c>")

-- tags
keymap("n", "<leader>ts", "<C-w><C-]>")
keymap("n", "<leader>tj", "<C-]>")
keymap("n", "<leader>tr", ":!ctags -R<CR>")

-- Quick spell fix
keymap("n", "<leader>z", "[s1z=<C-o>")
keymap("i", "<leader>z", "<C-g>u<ESC>[s1z=`]a<C-g>u")

-- Custom utility mappings
keymap("n", "<F5>", utils.writing_toggle)
keymap("n", "gs", utils.kill_white_space)
keymap("n", "<C-w>m", utils.toggle_max)
keymap("n", "<leader>W", "m[ggVGg<C-g><Esc>`[")
keymap("n", "<leader>F", utils.list_f_keys)
