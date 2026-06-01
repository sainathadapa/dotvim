local g = vim.g
local opt = vim.opt
local home = vim.env.HOME or ""
local tmp_root = vim.fs.joinpath(home, ".config", "nvim", "tmp")

g.mapleader = " "
g.maplocalleader = " "

g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_browse_split = 4
g.netrw_altv = 1
g.netrw_winsize = 25

opt.showmode = true
opt.visualbell = true
opt.tabstop = 2
opt.softtabstop = 0
opt.expandtab = true
opt.shiftwidth = 2
opt.cursorline = true
opt.showmatch = true
opt.number = true
opt.relativenumber = true
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.autoindent = true
opt.foldmethod = "manual"
opt.foldenable = true
opt.splitbelow = true
opt.splitright = true
opt.backspace = { "indent", "eol", "start" }
opt.clipboard:append({ "unnamedplus" })
opt.mouse = "a"
opt.display = "lastline"
opt.wildmenu = true
opt.wildmode = "list:longest"
opt.wildignore:append({ "*/tmp/*", "*.so", "*.swp", "*.zip", "*.exe" })
opt.nrformats:remove({ "octal" })
opt.scrolloff = 5
opt.signcolumn = "yes"
opt.updatetime = 300
opt.encoding = "utf-8"
opt.backup = false
opt.writebackup = false
opt.background = "light"
opt.undofile = true
opt.undolevels = 1000
opt.undoreload = 10000
opt.backupdir = vim.fs.joinpath(tmp_root, "backup") .. "//"
opt.directory = vim.fs.joinpath(tmp_root, "swap") .. "//"
opt.viewdir = vim.fs.joinpath(tmp_root, "view") .. "//"
opt.undodir = vim.fs.joinpath(tmp_root, "undo") .. "//"
opt.shadafile = vim.fs.joinpath(tmp_root, "main.shada")
