-- Modern, Lua-based markdown filetype configuration
-- Merges markdown.vim, markdown_folding.vim, and document_preview_bindings.vim

-- 1. Buffer-Local Options
vim.opt_local.expandtab = true
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.conceallevel = 2
vim.opt_local.foldlevel = 99

-- Enable unconstrained line lengths (soft wrapping) and visual wrap by default
vim.opt_local.textwidth = 0
vim.opt_local.wrap = true

-- Comment formatting
vim.opt_local.comments = "s:<!--,m:    ,e:-->"

-- Custom formatoptions adjustment for GHI (GitHub Issues templates)
if vim.fn.expand("%:t"):match("GHI_") then
  vim.opt_local.formatoptions:remove("t")
end

-- 2. Custom Section Toggling Function (ToggleSection)
local function toggle_section(level)
  local thisline = vim.fn.getline('.')
  local nextline = vim.fn.getline(vim.fn.line('.') + 1)
  local tline = vim.fn.line('.')

  if nextline:match("^=+$") then
    vim.cmd("normal! jdd")
  elseif nextline:match("^-+$") then
    vim.cmd("normal! jdd")
  elseif thisline:match("^### .* ###$") then
    vim.cmd("normal! 04x$3h4x")
  elseif thisline:match("^#### .* ####$") then
    vim.cmd("normal! 05x$4h5x")
  end

  vim.cmd("normal! " .. tline .. "G")
  
  local folded = false
  local foldline = tline - 1
  if vim.fn.foldclosed('.') > -1 then
    folded = true
    vim.cmd("normal! zO")
  end

  if level == 1 then
    vim.cmd("normal VypVr=")
  elseif level == 2 then
    vim.cmd("normal VypVr-")
  elseif level == 3 then
    vim.cmd("normal! I### \x1bA ###\x1b")
  elseif level == 4 then
    vim.cmd("normal! I#### \x1bA ####\x1b")
  end

  if folded then
    local curline = vim.fn.line('.')
    vim.cmd("normal! " .. foldline .. "G")
    vim.cmd("normal! za")
    vim.cmd("normal! " .. curline .. "G")
  end

  if vim.fn.line('.') == vim.fn.line('$') then
    vim.cmd("normal! o\x1b")
  end
end

-- 3. Folding (treesitter-based)
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- 4. Keymaps
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true, desc = desc })
end


-- Header toggling bindings
map("n", "<leader>1", function() toggle_section(1) end, "Set H1 Underline (=)")
map("i", "<leader>1", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>u", true, true, true), "n", true)
  toggle_section(1)
end, "Set H1 Underline (=)")

map("n", "<leader>2", function() toggle_section(2) end, "Set H2 Underline (-)")
map("i", "<leader>2", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>u", true, true, true), "n", true)
  toggle_section(2)
end, "Set H2 Underline (-)")

map("n", "<leader>3", function() toggle_section(3) end, "Set H3 (###)")
map("i", "<leader>3", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>u", true, true, true), "n", true)
  toggle_section(3)
end, "Set H3 (###)")

map("n", "<leader>4", function() toggle_section(4) end, "Set H4 (####)")
map("i", "<leader>4", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>u", true, true, true), "n", true)
  toggle_section(4)
end, "Set H4 (####)")
