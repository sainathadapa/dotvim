local map = vim.keymap.set

map("n", ";", ":", { silent = false })
map("n", ":", ";", { silent = false })
map("n", "gb", "`[v`]", { silent = true, desc = "Reselect last yanked text" })
map("n", "<leader><space>", "<cmd>nohlsearch<cr>", { silent = true, desc = "Clear search highlight" })

if vim.fn.has("gui_vimr") == 1 then
  map("n", "<D-l>", "<cmd>nohlsearch<cr><D-l>", { silent = true, desc = "Clear search highlight" })
  map("n", "<D-v>", "<C-v>", { silent = true })
  map("n", "<C-v>", "<Nop>", { silent = true })
  map("n", "<D-w>", "<C-w>", { silent = true })
  map("n", "<C-w>", "<Nop>", { silent = true })
end
