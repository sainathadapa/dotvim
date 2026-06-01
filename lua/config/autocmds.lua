local group = vim.api.nvim_create_augroup("sainatha_core", { clear = true })
local home = vim.env.HOME or ""
local tmp_root = vim.fs.joinpath(home, ".config", "nvim", "tmp")
local private_mode = tonumber("700", 8)

for _, dir in ipairs({
  tmp_root,
  vim.fs.joinpath(tmp_root, "backup"),
  vim.fs.joinpath(tmp_root, "swap"),
  vim.fs.joinpath(tmp_root, "view"),
  vim.fs.joinpath(tmp_root, "undo"),
}) do
  vim.fn.mkdir(dir, "p", private_mode)
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
