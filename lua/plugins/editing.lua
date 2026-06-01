return {
  {
    "tpope/vim-surround",
    event = "VeryLazy",
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
    },
  },
  {
    "unblevable/quick-scope",
    event = "VeryLazy",
  },
  {
    "gennaro-tedesco/nvim-peekup",
    event = "VeryLazy",
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  {
    "airblade/vim-rooter",
  },
  {
    "axvr/org.vim",
    ft = { "org" },
  },
}
