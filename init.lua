-- Set leader key before anything else (must run before any mappings or plugins load)
vim.g.mapleader = ","
vim.g.maplocalleader = ","


-- Load modular configuration settings
require("user.options")
require("user.keymaps")
require("user.autocmds")
require("user.lazy_setup")

