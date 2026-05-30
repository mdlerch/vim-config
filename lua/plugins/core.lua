--------------------------------------------------------------------------------
-- Core Plugins Specification Module
-- Purpose: Defines specifications for core editor integrations.
-- What goes here:
--  * LSP server configurations, Mason installers, and cmp autocompletion setups.
--  * Syntax editing utilities (like nvim-surround, rainbow-delimiters).
--  * Native Treesitter configs.
--------------------------------------------------------------------------------
return {


  -- LSP Management (Mason / Mason-lspconfig / Lspconfig)
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

  -- Autocompletions (nvim-cmp)
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

  -- Surround operators
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end
  },

  -- Rainbow Delimiters (Treesitter version)
  { "HiPhish/rainbow-delimiters.nvim" },
}
