local group = vim.api.nvim_create_augroup("sainatha_core", { clear = true })

for _, dir in ipairs({
  vim.fn.expand("$HOME/.config/nvim/tmp"),
  vim.fn.expand("$HOME/.config/nvim/tmp/backup"),
  vim.fn.expand("$HOME/.config/nvim/tmp/swap"),
  vim.fn.expand("$HOME/.config/nvim/tmp/view"),
  vim.fn.expand("$HOME/.config/nvim/tmp/undo"),
}) do
  vim.fn.mkdir(dir, "p")
end

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})
