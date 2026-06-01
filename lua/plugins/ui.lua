return {
  {
    "NLKNguyen/papercolor-theme",
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.background = "light"
      vim.cmd.colorscheme("PaperColor")
      vim.api.nvim_set_hl(0, "Comment", { italic = true })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({})
    end,
  },
  {
    "wellle/context.vim",
    cmd = "ContextToggle",
    init = function()
      vim.g.context_enabled = 0
    end,
  },
  {
    "machakann/vim-highlightedyank",
    event = "VeryLazy",
  },
}
