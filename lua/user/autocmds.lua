--------------------------------------------------------------------------------
-- Auto-commands Module
-- Purpose: Hooks event-driven events and auto-commands.
-- What goes here:
--  * vim.api.nvim_create_autocmd (start-up events, filetype setups, window entries).
--  * vim.api.nvim_create_augroup (event namespaces).
--------------------------------------------------------------------------------
-- Highlights that must be applied after the colorscheme loads (and re-applied
-- if the colorscheme ever changes).
local function apply_highlights()
    -- Extra whitespace
    vim.api.nvim_set_hl(0, "ExtraWhitespace", { fg = "red" })

    -- MatchParen: remove bold/underline added by some themes
    vim.api.nvim_set_hl(0, "MatchParen", { underline = false, bold = false })

    -- Statusline User groups (used by set_statusline in utils.lua)
    vim.api.nvim_set_hl(0, "User1", { bg = "#1c1c1c", fg = "#87afd7" })
    vim.api.nvim_set_hl(0, "User2", { bg = "#444444", fg = "#dfaf87" })
    vim.api.nvim_set_hl(0, "User3", { bg = "#1c1c1c", fg = "#ff0000" })
    vim.api.nvim_set_hl(0, "User4", { bg = "#444444", fg = "#87afd7" })
    vim.api.nvim_set_hl(0, "User5", { bg = "#444444", fg = "#87afd7" })
    vim.api.nvim_set_hl(0, "User6", { bg = "#444444", fg = "#87afd7" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = apply_highlights,
})

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
