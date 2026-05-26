-- Set leader key before anything else
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- Define Obsidian workspaces
local obsidian_workspaces = {
  {
    name = "personal",
    path = "~/vault",
  },
  {
    name = "pi",
    path = "~/pi/vault",
  },
  {
    name = "work",
    path = "~/work/repos/grc-product-vault",
  },
}

-- Plugin specification
require("lazy").setup({
  -- Core/LSP/Treesitter
  { 
    "nvim-treesitter/nvim-treesitter", 
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "c", "cpp", "python", "r", "lua", "vim", "markdown", "markdown_inline", "julia" },
        highlight = {
          enable = true,
          disable = { "markdown" },
        },
      })
    end
  },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "pyright", "r_language_server" },
        automatic_enable = true,
      })
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      vim.lsp.default_config = vim.lsp.default_config or {}
      vim.lsp.default_config = vim.tbl_deep_extend("force", vim.lsp.default_config, {
        capabilities = capabilities,
      })
    end
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        })
      })
    end
  },

  -- Modern Fuzzy Finder (Telescope)
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>f', builtin.find_files, {})
      vim.keymap.set('n', '<leader>a', builtin.live_grep, {}) -- The "Ag" style content search
      vim.keymap.set('n', '<leader>b', builtin.buffers, {})
    end
  },

  -- Modern Surround
  {
    "kylechui/nvim-surround",
    version = "*", 
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({})
    end
  },

  -- Obsidian support
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    event = (function()
      local events = {}
      for _, ws in ipairs(obsidian_workspaces) do
        local path = vim.fn.expand(ws.path)
        if vim.fn.isdirectory(path) == 1 then
          table.insert(events, "BufReadPre " .. path .. "/*.md")
          table.insert(events, "BufNewFile " .. path .. "/*.md")
          table.insert(events, "BufReadPre " .. path .. "/**/*.md")
          table.insert(events, "BufNewFile " .. path .. "/**/*.md")
        end
      end
      return events
    end)(),
    cmd = {
      "ObsidianToday",
      "ObsidianNew",
      "ObsidianQuickSwitch",
      "ObsidianFollowLink",
      "ObsidianBacklinks",
      "ObsidianTags",
      "ObsidianSearch",
      "ObsidianLink",
      "ObsidianLinkNew",
      "ObsidianLinks",
      "ObsidianTemplate",
      "ObsidianWorkspace",
      "ObsidianRename",
      "ObsidianPasteImg",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = (function()
        local existing = {}
        for _, ws in ipairs(obsidian_workspaces) do
          if vim.fn.isdirectory(vim.fn.expand(ws.path)) == 1 then
            table.insert(existing, ws)
          end
        end
        return existing
      end)(),
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      -- Performance: don't scan deep into files for aliases
      search_max_lines = 20,
      -- Asynchronous URL opening
      follow_url_func = function(url)
        vim.fn.jobstart({"open", url})
      end,
    },
    config = function(_, opts)
      require("obsidian").setup(opts)

      -- Smart gf passthrough
      vim.keymap.set("n", "gf", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          return "<cmd>ObsidianFollowLink<CR>"
        else
          return "gf"
        end
      end, { noremap = false, expr = true, buffer = true })

      -- Back button mapping
      vim.keymap.set("n", "<C-o>", "<C-t>", { buffer = true, desc = "Back to previous note" })
    end,
  },

  -- Visual Markdown rendering (Callouts, etc)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- or nvim-web-devicons
    opts = {},
  },

  -- Rainbow Delimiters (Treesitter version)
  { "HiPhish/rainbow-delimiters.nvim" },

  -- Preserved Plugins
  "tpope/vim-repeat",
  "mdlerch/tungsten.vim",
  "mdlerch/yttrium.vim",
  "jnurmine/Zenburn",
  "vasconcelloslf/vim-interestingwords",
  "mdlerch/mc-stan.vim",
  "mdlerch/psql.nvim",
  "mdlerch/R-Vim-runtime",
  "keith/tmux.vim",
  "vim-scripts/gnuplot.vim",
  "mdlerch/Nvim-R",
  "dhruvasagar/vim-table-mode",
  "tommcdo/vim-exchange",
  "godlygeek/tabular",
  "gcavallanti/vim-noscrollbar",
})

-- Load core settings, mappings, and functions
require('core')
