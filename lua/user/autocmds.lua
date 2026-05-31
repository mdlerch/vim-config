--------------------------------------------------------------------------------
-- Auto-commands Module
-- Purpose: Hooks event-driven events and auto-commands.
-- What goes here:
--  * vim.api.nvim_create_autocmd (start-up events, filetype setups, window entries).
--  * vim.api.nvim_create_augroup (event namespaces).
--------------------------------------------------------------------------------
-- Extra whitespace highlights
vim.api.nvim_set_hl(0, "ExtraWhitespace", { fg = "red" })

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

-- Statusline custom highlights and updates
local status_group = vim.api.nvim_create_augroup("status", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
    group = status_group,
    callback = function()
        for winnum = 1, vim.fn.winnr('$') do
            vim.fn.setwinvar(winnum, '&statusline', '%!v:lua.require("user.utils").set_statusline(' .. winnum .. ')')
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
