--------------------------------------------------------------------------------
-- Telescope Plugin Specification Module
-- Purpose: Defines the Telescope fuzzy-finder plugin and its maps.
-- What goes here:
--  * telescope.nvim configuration parameters (sorting, ignores, extensions).
--  * Local Telescope hotkey definitions (finding files, live grep, buffers).
--------------------------------------------------------------------------------
return {

  -- Telescope Fuzzy Finder (tracking master for Neovim 0.12+ compatibility)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>f', builtin.find_files, {})
      vim.keymap.set('n', '<leader>a', builtin.live_grep, {}) -- The "Ag" style content search
      vim.keymap.set('n', '<leader>b', builtin.buffers, {})
    end
  }
}
