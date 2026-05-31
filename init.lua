-- Set leader key before anything else (must run before any mappings or plugins load)
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Compatibility shims for plugins using deprecated nvim-treesitter APIs in Neovim 0.12+
-- (Protects Telescope previewers and other plugins from missing parser/configs methods)
package.preload["nvim-treesitter.parsers"] = function()
  return {
    ft_to_lang = function(ft)
      return ft and vim.treesitter.language.get_lang(ft) or nil
    end,
    get_parser = function(bufnr, lang)
      return vim.treesitter.get_parser(bufnr, lang)
    end,
    has_parser = function(lang)
      return lang and pcall(vim.treesitter.language.require_language, lang) or false
    end,
    get_parser_configs = function()
      return {}
    end,
  }
end

package.preload["nvim-treesitter.configs"] = function()
  return {
    is_enabled = function(module_name, lang, bufnr)
      if module_name == "highlight" then
        return true
      end
      return false
    end,
    get_module = function()
      return nil
    end,
  }
end

-- Load modular configuration settings
require("user.options")
require("user.keymaps")
require("user.autocmds")
require("user.lazy_setup")

