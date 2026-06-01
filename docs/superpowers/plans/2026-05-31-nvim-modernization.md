# Neovim Modernization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the current Coc plus `vim-plug` Neovim configuration with a Lua-first `lazy.nvim` setup that works in both `nvim` and VimR and supports Lua, Python, JSON, YAML, Markdown, SQL, Java, and Scala in phase 1.

**Architecture:** Keep `init.vim` as a thin compatibility entrypoint, move real behavior into `lua/config/*` and `lua/plugins/*`, and use Neovim's native LSP client plus a small modern plugin stack for completion, formatting, discovery, and language tooling. Handle the current detached-HEAD repository state explicitly by creating a safety branch for the existing dirty config before creating the migration branch.

**Tech Stack:** Neovim 0.12, Lua, `folke/lazy.nvim`, `nvim-telescope/telescope.nvim`, `nvim-treesitter/nvim-treesitter`, `saghen/blink.cmp`, `stevearc/conform.nvim`, `mason-org/mason.nvim`, `mason-org/mason-lspconfig.nvim`, `WhoIsSethDaniel/mason-tool-installer.nvim`, `neovim/nvim-lspconfig`, `mfussenegger/nvim-jdtls`, `scalameta/nvim-metals`, `b0o/SchemaStore.nvim`, Homebrew `openjdk@21`, and Homebrew `coursier`.

---

## Planned File Structure

**Modify**

- `init.vim`
- `README.md`

**Create**

- `lua/config/init.lua`
- `lua/config/lazy.lua`
- `lua/config/options.lua`
- `lua/config/autocmds.lua`
- `lua/config/keymaps.lua`
- `lua/config/lsp.lua`
- `lua/config/java.lua`
- `lua/config/scala.lua`
- `lua/plugins/ui.lua`
- `lua/plugins/editing.lua`
- `lua/plugins/telescope.lua`
- `lua/plugins/lsp.lua`
- `lua/plugins/java.lua`
- `lua/plugins/scala.lua`
- `ftplugin/java.lua`
- `ftplugin/scala.lua`
- `ftplugin/sbt.lua`
- `lazy-lock.json`

**Delete**

- `autoload/plug.vim`
- `autoload/plug.vim.old`
- `coc-settings.json`

## Task 1: Preserve The Current Dirty State And Create The Migration Branch

**Files:**
- Modify: `.git` metadata only

- [ ] **Step 1: Verify the current repository state before changing branches**

Run:

```bash
git status --short
git rev-parse --abbrev-ref HEAD
git log --oneline -2
```

Expected:

- `git rev-parse --abbrev-ref HEAD` prints `HEAD`
- `git status --short` shows the modified config files:
  - `autoload/plug.vim`
  - `autoload/plug.vim.old`
  - `init.vim`

- [ ] **Step 2: Create a safety branch from the current detached HEAD**

Run:

```bash
git switch -c codex/nvim-preserve-current-state
```

Expected: Git reports a new branch named `codex/nvim-preserve-current-state`.

- [ ] **Step 3: Commit the current pre-migration config changes on the safety branch**

Run:

```bash
git add autoload/plug.vim autoload/plug.vim.old init.vim
git commit -m "chore: preserve pre-migration Neovim state"
```

Expected: A commit is created that contains only the three pre-existing dirty config files.

- [ ] **Step 4: Create the actual migration branch from the preserved state**

Run:

```bash
git switch -c codex/nvim-modernize-native-lsp
```

Expected: Git reports a new branch named `codex/nvim-modernize-native-lsp`.

- [ ] **Step 5: Verify the migration branch starts from the preserved commit**

Run:

```bash
git status --short
git branch --show-current
git log --oneline -2
```

Expected:

- `git branch --show-current` prints `codex/nvim-modernize-native-lsp`
- `git status --short` is clean
- the most recent commit is `chore: preserve pre-migration Neovim state`

## Task 2: Bootstrap The Lua Entry Point And `lazy.nvim`

**Files:**
- Modify: `init.vim`
- Create: `lua/config/init.lua`
- Create: `lua/config/lazy.lua`

- [ ] **Step 1: Confirm the Lua entrypoint does not exist yet**

Run:

```bash
nvim --headless "+lua require('config')" +qall
```

Expected: FAIL with `module 'config' not found`.

- [ ] **Step 2: Replace `init.vim` with a thin Lua bootstrap**

Write `init.vim` as:

```vim
lua require("config")
```

- [ ] **Step 3: Create `lua/config/init.lua`**

Write `lua/config/init.lua` as:

```lua
require("config.lazy")
```

- [ ] **Step 4: Create `lua/config/lazy.lua`**

Write `lua/config/lazy.lua` as:

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    error("Failed to clone lazy.nvim:\n" .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  change_detection = { notify = false },
  checker = { enabled = true },
})
```

- [ ] **Step 5: Verify Neovim can load the new bootstrap path**

Run:

```bash
nvim --headless "+lua require('config')" +qall
```

Expected: PASS with exit code `0`.

- [ ] **Step 6: Commit the bootstrap**

Run:

```bash
git add init.vim lua/config/init.lua lua/config/lazy.lua
git commit -m "refactor: bootstrap Lua config with lazy.nvim"
```

## Task 3: Port Core Options, Autocmds, And Keymaps

**Files:**
- Modify: `lua/config/init.lua`
- Create: `lua/config/options.lua`
- Create: `lua/config/autocmds.lua`
- Create: `lua/config/keymaps.lua`

- [ ] **Step 1: Confirm the core modules do not exist yet**

Run:

```bash
nvim --headless "+lua require('config.options')" +qall
```

Expected: FAIL with `module 'config.options' not found`.

- [ ] **Step 2: Update `lua/config/init.lua` to load all core config modules**

Write `lua/config/init.lua` as:

```lua
require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.lazy")
```

- [ ] **Step 3: Create `lua/config/options.lua`**

Write `lua/config/options.lua` as:

```lua
local g = vim.g
local opt = vim.opt

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
opt.backupdir = vim.fn.expand("$HOME/.config/nvim/tmp/backup//")
opt.directory = vim.fn.expand("$HOME/.config/nvim/tmp/swap//")
opt.viewdir = vim.fn.expand("$HOME/.config/nvim/tmp/view//")
opt.undodir = vim.fn.expand("$HOME/.config/nvim/tmp/undo//")
opt.shadafile = vim.fn.expand("$HOME/.config/nvim/tmp/main.shada")
```

- [ ] **Step 4: Create `lua/config/autocmds.lua`**

Write `lua/config/autocmds.lua` as:

```lua
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
```

- [ ] **Step 5: Create `lua/config/keymaps.lua`**

Write `lua/config/keymaps.lua` as:

```lua
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
```

- [ ] **Step 6: Verify the core config loads and applies the expected options**

Run:

```bash
nvim --headless "+lua print(vim.o.number, vim.o.relativenumber, vim.o.splitbelow, vim.o.splitright)" +qall
```

Expected:

```text
true true true true
```

- [ ] **Step 7: Commit the core config port**

Run:

```bash
git add lua/config/init.lua lua/config/options.lua lua/config/autocmds.lua lua/config/keymaps.lua
git commit -m "refactor: port core Neovim settings to Lua"
```

## Task 4: Add The Base UI And Editing Plugin Layer

**Files:**
- Create: `lua/plugins/ui.lua`
- Create: `lua/plugins/editing.lua`

- [ ] **Step 1: Create `lua/plugins/ui.lua`**

Write `lua/plugins/ui.lua` as:

```lua
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
```

- [ ] **Step 2: Create `lua/plugins/editing.lua`**

Write `lua/plugins/editing.lua` as:

```lua
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
    event = "VeryLazy",
  },
  {
    "axvr/org.vim",
    ft = { "org" },
  },
}
```

- [ ] **Step 3: Install the base plugins**

Run:

```bash
nvim --headless "+Lazy! sync" +qall
```

Expected: PASS with plugin installation output and exit code `0`.

- [ ] **Step 4: Verify the colorscheme and highlight customizations load**

Run:

```bash
nvim --headless "+lua print(vim.g.colors_name)" +qall
```

Expected:

```text
PaperColor
```

- [ ] **Step 5: Commit the base plugin layer**

Run:

```bash
git add lua/plugins/ui.lua lua/plugins/editing.lua
git commit -m "feat: add base UI and editing plugins"
```

## Task 5: Replace CtrlP With Telescope

**Files:**
- Create: `lua/plugins/telescope.lua`

- [ ] **Step 1: Create `lua/plugins/telescope.lua`**

Write `lua/plugins/telescope.lua` as:

```lua
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<D-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = "  ",
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
        },
      })
    end,
  },
}
```

- [ ] **Step 2: Sync plugins so Telescope is installed**

Run:

```bash
nvim --headless "+Lazy! sync" +qall
```

Expected: PASS with `telescope.nvim` and `plenary.nvim` installed.

- [ ] **Step 3: Verify the Telescope command exists**

Run:

```bash
nvim --headless "+lua print(vim.fn.exists(':Telescope'))" +qall
```

Expected:

```text
2
```

- [ ] **Step 4: Commit the finder migration**

Run:

```bash
git add lua/plugins/telescope.lua
git commit -m "feat: replace CtrlP with Telescope"
```

## Task 6: Add Tree-sitter, Completion, Formatting, Mason, And Generic LSP Setup

**Files:**
- Create: `lua/config/lsp.lua`
- Create: `lua/plugins/lsp.lua`

- [ ] **Step 1: Create `lua/config/lsp.lua`**

Write `lua/config/lsp.lua` as:

```lua
local M = {}

M.capabilities = require("blink.cmp").get_lsp_capabilities()

function M.on_attach(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "gi", vim.lsp.buf.implementation, "Implementation")
  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
  map("n", "<leader>e", vim.diagnostic.open_float, "Line diagnostics")
  map("n", "<leader>f", function()
    require("conform").format({ async = true, lsp_fallback = true })
  end, "Format buffer")
end

M.servers = {
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
  pyright = {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
        },
      },
    },
  },
  jsonls = {
    settings = {
      json = {
        validate = { enable = true },
        schemas = require("schemastore").json.schemas(),
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        keyOrdering = false,
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = require("schemastore").yaml.schemas(),
      },
    },
  },
  marksman = {},
  sqls = {},
}

return M
```

- [ ] **Step 2: Create `lua/plugins/lsp.lua`**

Write `lua/plugins/lsp.lua` as:

```lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "java",
          "json",
          "lua",
          "markdown",
          "python",
          "scala",
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
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("blink.cmp").setup({
        keymap = { preset = "default" },
        appearance = { nerd_font_variant = "mono" },
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
          java = { "google-java-format" },
        },
        format_on_save = function(bufnr)
          return {
            timeout_ms = 2000,
            lsp_fallback = vim.bo[bufnr].filetype ~= "java",
          }
        end,
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
          "google-java-format",
          "jdtls",
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
        ensure_installed = {
          "lua_ls",
          "pyright",
          "jsonls",
          "yamlls",
          "marksman",
          "sqls",
        },
        automatic_enable = false,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    config = function()
      local lsp = require("config.lsp")
      local lspconfig = require("lspconfig")

      for name, config in pairs(lsp.servers) do
        config.capabilities = lsp.capabilities
        config.on_attach = lsp.on_attach
        lspconfig[name].setup(config)
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
```

- [ ] **Step 3: Sync plugins and install Mason-managed tools**

Run:

```bash
nvim --headless "+Lazy! sync" "+MasonToolsInstallSync" +qall
```

Expected: PASS with the plugin set installed and Mason tools installed.

- [ ] **Step 4: Verify the shared formatters are available**

Run:

```bash
nvim --headless "+lua print(vim.fn.executable('stylua'), vim.fn.executable('ruff'), vim.fn.executable('prettier'))" +qall
```

Expected:

```text
1 1 1
```

- [ ] **Step 5: Verify the generic LSP servers are configured**

Run:

```bash
nvim --headless "+lua for _, name in ipairs({ 'lua_ls', 'pyright', 'jsonls', 'yamlls', 'marksman', 'sqls' }) do print(name, require('lspconfig.configs')[name] ~= nil) end" +qall
```

Expected:

```text
lua_ls true
pyright true
jsonls true
yamlls true
marksman true
sqls true
```

- [ ] **Step 6: Commit the LSP foundation**

Run:

```bash
git add lua/config/lsp.lua lua/plugins/lsp.lua
git commit -m "feat: add native LSP, completion, formatting, and treesitter"
```

## Task 7: Add Java Support With `nvim-jdtls`

**Files:**
- Create: `lua/plugins/java.lua`
- Create: `lua/config/java.lua`
- Create: `ftplugin/java.lua`

- [ ] **Step 1: Install the Java runtime prerequisite**

Run:

```bash
brew install openjdk@21
```

Expected: Homebrew installs `openjdk@21` under `/Users/sainatha/homebrew/opt/openjdk@21`.

- [ ] **Step 2: Verify the Java 21 runtime exists at the expected path**

Run:

```bash
/Users/sainatha/homebrew/opt/openjdk@21/bin/java -version
```

Expected: PASS and the version output mentions `21`.

- [ ] **Step 3: Create `lua/plugins/java.lua`**

Write `lua/plugins/java.lua` as:

```lua
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
  },
}
```

- [ ] **Step 4: Create `lua/config/java.lua`**

Write `lua/config/java.lua` as:

```lua
local M = {}

function M.setup()
  local root_dir = require("jdtls.setup").find_root({
    ".git",
    "mvnw",
    "gradlew",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "settings.gradle",
    "settings.gradle.kts",
  })

  if root_dir == "" then
    return
  end

  local registry = require("mason-registry")
  local jdtls_pkg = registry.get_package("jdtls")
  local install_path = jdtls_pkg:get_install_path()
  local launcher = vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. project_name

  vim.fn.mkdir(workspace_dir, "p")

  require("jdtls").start_or_attach({
    cmd = {
      "/Users/sainatha/homebrew/opt/openjdk@21/bin/java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=WARN",
      "-Xms1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
      "-jar",
      launcher,
      "-configuration",
      install_path .. "/config_mac",
      "-data",
      workspace_dir,
    },
    root_dir = root_dir,
    capabilities = require("config.lsp").capabilities,
    on_attach = require("config.lsp").on_attach,
    settings = {
      java = {
        format = { enabled = false },
        signatureHelp = { enabled = true },
      },
    },
  })
end

return M
```

- [ ] **Step 5: Create `ftplugin/java.lua`**

Write `ftplugin/java.lua` as:

```lua
require("config.java").setup()
```

- [ ] **Step 6: Verify a temporary Java project attaches `jdtls`**

Run:

```bash
tmpdir="$(mktemp -d)"
mkdir -p "$tmpdir/src/main/java/example"
cat > "$tmpdir/pom.xml" <<'EOF'
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>example</groupId>
  <artifactId>demo</artifactId>
  <version>1.0.0</version>
</project>
EOF
cat > "$tmpdir/src/main/java/example/App.java" <<'EOF'
package example;

class App {
  public static void main(String[] args) {
    System.out.println("hello");
  }
}
EOF
nvim --headless "$tmpdir/src/main/java/example/App.java" "+sleep 10000m" "+lua local names = {} for _, client in ipairs(vim.lsp.get_clients()) do table.insert(names, client.name) end print(table.concat(names, ','))" +qall
```

Expected: Output includes `jdtls`.

- [ ] **Step 7: Commit the Java integration**

Run:

```bash
git add lua/plugins/java.lua lua/config/java.lua ftplugin/java.lua
git commit -m "feat: add Java support with nvim-jdtls"
```

## Task 8: Add Scala Support With `nvim-metals`

**Files:**
- Create: `lua/plugins/scala.lua`
- Create: `lua/config/scala.lua`
- Create: `ftplugin/scala.lua`
- Create: `ftplugin/sbt.lua`

- [ ] **Step 1: Install the Coursier prerequisite**

Run:

```bash
brew install coursier
```

Expected: Homebrew installs `cs` into `/Users/sainatha/homebrew/bin/cs`.

- [ ] **Step 2: Verify Coursier is available**

Run:

```bash
cs --help | sed -n '1,5p'
```

Expected: PASS with the Coursier help header.

- [ ] **Step 3: Create `lua/plugins/scala.lua`**

Write `lua/plugins/scala.lua` as:

```lua
return {
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
```

- [ ] **Step 4: Create `lua/config/scala.lua`**

Write `lua/config/scala.lua` as:

```lua
local M = {}

function M.setup()
  local metals = require("metals")
  local config = metals.bare_config()

  config.capabilities = require("config.lsp").capabilities
  config.on_attach = require("config.lsp").on_attach
  config.settings = {
    showImplicitArguments = true,
    showInferredType = true,
  }

  metals.initialize_or_attach(config)
end

return M
```

- [ ] **Step 5: Create the Scala ftplugin entrypoints**

Write `ftplugin/scala.lua` as:

```lua
require("config.scala").setup()
```

Write `ftplugin/sbt.lua` as:

```lua
require("config.scala").setup()
```

- [ ] **Step 6: Verify a temporary Scala project attaches Metals**

Run:

```bash
tmpdir="$(mktemp -d)"
mkdir -p "$tmpdir/src/main/scala/example"
cat > "$tmpdir/build.sbt" <<'EOF'
scalaVersion := "2.13.16"
EOF
cat > "$tmpdir/src/main/scala/example/App.scala" <<'EOF'
package example

object App extends App {
  println("hello")
}
EOF
nvim --headless "$tmpdir/src/main/scala/example/App.scala" "+sleep 15000m" "+lua local names = {} for _, client in ipairs(vim.lsp.get_clients()) do table.insert(names, client.name) end print(table.concat(names, ','))" +qall
```

Expected: Output includes `metals`.

- [ ] **Step 7: Commit the Scala integration**

Run:

```bash
git add lua/plugins/scala.lua lua/config/scala.lua ftplugin/scala.lua ftplugin/sbt.lua
git commit -m "feat: add Scala support with nvim-metals"
```

## Task 9: Remove Coc And `vim-plug`, Rewrite The README, And Regenerate The Lockfile

**Files:**
- Modify: `README.md`
- Delete: `autoload/plug.vim`
- Delete: `autoload/plug.vim.old`
- Delete: `coc-settings.json`
- Create: `lazy-lock.json`

- [ ] **Step 1: Delete the legacy Coc and `vim-plug` files**

Run:

```bash
git rm autoload/plug.vim autoload/plug.vim.old coc-settings.json
```

Expected: Git stages all three files for deletion.

- [ ] **Step 2: Rewrite `README.md` for the new stack**

Write `README.md` as:

````md
Configuration for using Neovim directly or through VimR on macOS.

## Install

1. Clone this repo into `~/.config/nvim`.
2. Start `nvim` or VimR once to let `lazy.nvim` install plugins.
3. Run `:MasonToolsInstallSync` to install managed tools.
4. Install Java and Scala prerequisites:

```bash
brew install openjdk@21 coursier
```

5. Restart `nvim` after the first install pass.

## Useful Commands

- `:Lazy sync`
- `:Mason`
- `:checkhealth`
- `:Telescope find_files`
````

- [ ] **Step 3: Verify the repo no longer references Coc or `Plug` declarations outside the design docs**

Run:

```bash
git grep -nE "coc#|Coc[A-Z]|plug#begin|plug#end|^Plug " -- . ":(exclude)docs/**"
```

Expected: No matches.

- [ ] **Step 4: Regenerate plugin state and create `lazy-lock.json`**

Run:

```bash
nvim --headless "+Lazy! sync" "+MasonToolsInstallSync" +qall
```

Expected: PASS and `lazy-lock.json` exists in the repo root.

- [ ] **Step 5: Commit the cleanup and docs update**

Run:

```bash
git add README.md lazy-lock.json
git commit -m "refactor: remove Coc and migrate plugin manager"
```

## Task 10: Run The Final Verification Pass In `nvim` And VimR

**Files:**
- Modify: none

- [ ] **Step 1: Run a clean headless startup check**

Run:

```bash
nvim --headless +qall
```

Expected: PASS with exit code `0`.

- [ ] **Step 2: Run focused health checks for the core editor subsystems**

Run:

```bash
nvim --headless "+checkhealth vim.lsp" "+checkhealth mason" "+checkhealth telescope" +qall
```

Expected: PASS without startup errors.

- [ ] **Step 3: Verify the generic LSP and formatting commands are present**

Run:

```bash
nvim --headless "+lua print(vim.fn.exists(':Mason'), vim.fn.exists(':Telescope'))" +qall
```

Expected:

```text
2 2
```

- [ ] **Step 4: Verify the VimR-specific experience manually**

Open VimR with this repo loaded and verify:

```text
1. <D-p> opens Telescope file search.
2. <D-l> clears search highlighting.
3. <D-v> behaves like visual block mode.
4. The PaperColor theme loads without startup errors.
```

Expected: All four checks succeed.

- [ ] **Step 5: Create the final migration checkpoint commit**

Run:

```bash
git status --short
git commit --allow-empty -m "chore: verify native LSP migration"
```

Expected:

- `git status --short` is empty before the empty commit.
- the empty commit marks the verified end of the migration branch.

## Self-Review

### Spec Coverage

- Git safety and detached-HEAD handling: Task 1
- Lua-first config shape and lazy bootstrap: Tasks 2 and 3
- Preserved editing behavior and VimR mappings: Tasks 3, 4, and 10
- Lean modern plugin stack: Tasks 4, 5, and 6
- Native LSP, completion, formatting, Treesitter: Task 6
- Generic language coverage for Lua, Python, JSON, YAML, Markdown, SQL: Task 6
- Java phase 1 support: Task 7
- Scala phase 1 support: Task 8
- Coc and `vim-plug` removal: Task 9
- README and verification strategy: Tasks 9 and 10

### Placeholder Scan

- No placeholder markers remain.
- Each code step includes complete file contents.
- Each verification step includes an exact command and expected output.

### Type And Naming Consistency

- Shared LSP helpers live in `lua/config/lsp.lua` and are referenced consistently from generic LSP, Java, and Scala tasks.
- Java setup uses `require("config.java").setup()` in `ftplugin/java.lua`.
- Scala setup uses `require("config.scala").setup()` in both `ftplugin/scala.lua` and `ftplugin/sbt.lua`.
