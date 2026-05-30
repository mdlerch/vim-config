--------------------------------------------------------------------------------
-- Obsidian Integration Plugin Module
-- Purpose: Integrates Obsidian workspace indexing, links, and templates.
-- What goes here:
--  * Local workspace configurations and path definitions.
--  * obsidian.nvim properties (keymaps, completion, template structures).
--  * Event-driven lazy-loading conditions.
--------------------------------------------------------------------------------
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

return {
  -- Obsidian note-taking support
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
      search_max_lines = 20,
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
  }
}
