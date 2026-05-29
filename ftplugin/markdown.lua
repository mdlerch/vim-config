-- Modern, Lua-based markdown filetype configuration
-- Merges markdown.vim, markdown_folding.vim, and document_preview_bindings.vim

-- 1. Buffer-Local Options
vim.opt_local.expandtab = true
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.conceallevel = 2
vim.opt_local.foldlevel = 99

-- Set text width to 79 if writing_on is not defined or 0
local writing_on = vim.b.writing_on
if not writing_on or writing_on == 0 then
  vim.opt_local.textwidth = 79
end

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

-- 3. Custom Folding Logic (MarkdownFoldSection and MarkdownFoldText)
_G.MarkdownFoldSection = function()
  local lnum = vim.v.lnum
  local tline = vim.fn.getline(lnum)
  local pline = vim.fn.getline(lnum - 1)
  local nline = vim.fn.getline(lnum + 1)

  -- Headers
  if nline:match("^====+") then
    return ">1"
  elseif nline:match("^----+") then
    return ">2"
  elseif tline:match("^%-%-%-+") and pline == "" and nline == "" then
    return ">2"
  elseif tline:match("^### ") then
    return ">3"
  elseif tline:match("^#### ") then
    return ">4"
  end

  -- Code chunk
  if tline:match("^%s*```{") then
    return "a1"
  elseif tline:match("^%s*```$") then
    return "s1"
  end

  return "="
end

_G.MarkdownFoldText = function()
  local foldstart = vim.v.foldstart
  local foldend = vim.v.foldend
  local tline = vim.fn.getline(foldstart)
  local foldsize = foldend - foldstart
  local foldlevel = vim.fn.foldlevel(foldstart)

  local title = ""
  if tline:match("^%s*```{r ") then
    title = tline:gsub("^%s*```{r%s*", ""):gsub("%W.*$", "")
    title = "    ~~~ " .. title .. " " .. foldsize .. " lines "
  else
    title = tline:gsub("#", "")
    title = title:gsub("^%s*", ""):gsub("%s*$", "")
    
    if foldlevel == 1 then
      title = "# " .. title
    elseif foldlevel == 2 then
      title = "    # " .. title
    elseif foldlevel >= 3 then
      title = "        # " .. title
    end
    title = title .. " [" .. foldsize .. " lines]" .. " (" .. foldlevel .. ") "
  end
  return title
end

vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.MarkdownFoldSection()"
vim.opt_local.foldtext = "v:lua.MarkdownFoldText()"

-- 4. Keymaps
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true, desc = desc })
end

-- Preview bindings (LaunchPDF / LaunchHTML)
map("n", "<leader>sd", "<ESC>:call LaunchPDF()<CR>", "Launch PDF Preview")
map("i", "<leader>sd", "<ESC>:call LaunchPDF()<CR>", "Launch PDF Preview")
map("n", "<leader>sh", "<ESC>:call LaunchHTML()<CR>", "Launch HTML Preview")
map("i", "<leader>sh", "<ESC>:call LaunchHTML()<CR>", "Launch HTML Preview")

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
