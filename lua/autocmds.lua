--------------------------------------------------------------------------------
-- Auto-commands and Highlights Module
-- Purpose: Hooks event-driven events, auto-commands, and highlight overrides.
-- What goes here:
--  * vim.api.nvim_create_autocmd (start-up events, filetype setups, window entries).
--  * vim.api.nvim_create_augroup (event namespaces).
--  * vim.api.nvim_set_hl (custom highlight groups like MatchParen or User statusline).
--------------------------------------------------------------------------------
-- Extra whitespace highlights
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

-- MatchParen styling
vim.api.nvim_set_hl(0, "MatchParen", { underline = false, bold = false })

-- Statusline custom highlights and updates
local status_group = vim.api.nvim_create_augroup("status", { clear = true })

vim.api.nvim_set_hl(0, "User1", { bg = "#1c1c1c", fg = "#87afd7" })
vim.api.nvim_set_hl(0, "User2", { bg = "#444444", fg = "#dfaf87" })
vim.api.nvim_set_hl(0, "User3", { bg = "#1c1c1c", fg = "#ff0000" })
vim.api.nvim_set_hl(0, "User4", { bg = "#444444", fg = "#87afd7" })
vim.api.nvim_set_hl(0, "User5", { bg = "#444444", fg = "#87afd7" })
vim.api.nvim_set_hl(0, "User6", { bg = "#444444", fg = "#87afd7" })

vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
    group = status_group,
    callback = function()
        for winnum = 1, vim.fn.winnr('$') do
            vim.fn.setwinvar(winnum, '&statusline', '%!v:lua.require("utils").set_statusline(' .. winnum .. ')')
        end
    end,
})

-- Auto-position cursor to last saved edit position on load
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local line = vim.fn.line("'\"")
        if line > 1 and line <= vim.fn.line("$") then
            vim.cmd([[normal! g`"]])
        end
    end,
})
