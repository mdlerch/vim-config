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
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      local builtin = require('telescope.builtin')
      local actions = require('telescope.actions')
      require('telescope').setup({
        defaults = {
          preview = {
            treesitter = false,
          },
          mappings = {
            i = {
              ['<C-s>'] = actions.select_horizontal,
            },
            n = {
              ['<C-s>'] = actions.select_horizontal,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        }
      })
      require('telescope').load_extension('fzf')
      vim.keymap.set('n', '<leader>f', builtin.find_files, {})
      vim.keymap.set('n', '<leader>a', builtin.live_grep, {}) -- The "Ag" style content search
      vim.keymap.set('n', '<leader>b', builtin.buffers, {})
    end
  }
}
