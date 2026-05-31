--------------------------------------------------------------------------------
-- Package Manager Setup Module
-- Purpose: Boots the Lazy.nvim package manager and imports plugin definitions.
-- What goes here:
--  * lazy.nvim download and bootstrapping logic.
--  * lazy.nvim configuration and directory scanning ({ import = "plugins" }).
--------------------------------------------------------------------------------
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim, automatically importing all specifications inside lua/plugins/
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  -- You can add general lazy.nvim options here if needed in the future
})
