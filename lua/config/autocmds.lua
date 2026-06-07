local group = vim.api.nvim_create_augroup("sainatha_core", { clear = true })
local home = vim.env.HOME or ""
local tmp_root = vim.fs.joinpath(home, ".config", "nvim", "tmp")
local private_mode = tonumber("700", 8)
local lazy_update_state = vim.fs.joinpath(vim.fn.stdpath("state"), "lazy", "auto-update.json")
local lazy_update_interval = 7 * 24 * 60 * 60

local function read_last_lazy_update()
  local ok, lines = pcall(vim.fn.readfile, lazy_update_state)
  if not ok or #lines == 0 then
    return 0
  end

  local ok_json, data = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not ok_json or type(data) ~= "table" then
    return 0
  end

  return tonumber(data.last_update) or 0
end

local function write_last_lazy_update(timestamp)
  vim.fn.mkdir(vim.fn.fnamemodify(lazy_update_state, ":p:h"), "p")
  vim.fn.writefile({ vim.json.encode({ last_update = timestamp }) }, lazy_update_state)
end

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

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "VeryLazy",
  once = true,
  callback = function()
    local now = os.time()
    if now - read_last_lazy_update() < lazy_update_interval then
      return
    end

    write_last_lazy_update(now)
    require("lazy.manage").update({ show = false })
  end,
})
