--------------------------------------------------------------------------------
-- Core Plugins Specification Module
-- Purpose: Defines specifications for core editor integrations.
-- What goes here:
--  * LSP server configurations, Mason installers, and cmp autocompletion setups.
--  * Syntax editing utilities (like nvim-surround, rainbow-delimiters).
--  * Native Treesitter configs.
--------------------------------------------------------------------------------
return {

  -- Treesitter: archived but functional on Neovim 0.12. Pinned to prevent
  -- accidental updates. Revisit in a few months for a native replacement.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    pin = true,
    build = ":TSUpdate",
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then return end
      configs.setup({
        ensure_installed = {
          -- Data science / academic
          "python", "r", "julia", "sql",
          -- Systems / scripting
          "c", "lua", "bash",
          -- Web (new work)
          "typescript", "tsx", "javascript", "jsdoc", "html", "css",
          -- Config / data formats
          "yaml", "json", "toml",
          -- Markup / docs
          "markdown", "markdown_inline", "vim", "vimdoc", "regex",
        },
        highlight = { enable = true },
      })
    end,
  },

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

  -- Snippet Engine (LuaSnip + Friendly Snippets)
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      -- Load VSCode-style snippets (like friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
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
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require("luasnip").expand_or_locally_jumpable() then
              require("luasnip").expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require("luasnip").locally_jumpable(-1) then
              require("luasnip").jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp', keyword_length = 2 },
          { name = 'luasnip', keyword_length = 2 },
        }, {
          { name = 'buffer', keyword_length = 3 },
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
