local has_go = vim.fn.executable("go") == 1
local lsp_servers = {
  "lua_ls",
  "pyright",
  "jsonls",
  "yamlls",
  "marksman",
}

-- Mason installs sqls through Go, so only enable it when Go is available.
if has_go then
  table.insert(lsp_servers, "sqls")
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "json",
          "lua",
          "markdown",
          "python",
          "sql",
          "vim",
          "vimdoc",
          "yaml",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = {
          enable = true,
          disable = { "python" },
        },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    build = function()
      require("blink.cmp").build():pwait()
    end,
    dependencies = {
      "saghen/blink.lib",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("blink.cmp").setup({
        keymap = { preset = "default" },
        appearance = { nerd_font_variant = "mono" },
        fuzzy = { implementation = "rust" },
        completion = {
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
          },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "ruff_format" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          sql = { "sql_formatter" },
        },
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason.nvim",
    },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",
          "ruff",
          "prettier",
          "sql-formatter",
        },
        run_on_start = true,
      })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = lsp_servers,
        automatic_enable = false,
      })
    end,
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    config = function()
      local lsp = require("config.lsp")

      for name, config in pairs(lsp.servers) do
        config.capabilities = lsp.capabilities
        config.on_attach = lsp.on_attach
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end

      vim.diagnostic.config({
        float = { border = "rounded" },
        severity_sort = true,
        update_in_insert = false,
        virtual_text = true,
        signs = true,
      })
    end,
  },
}
