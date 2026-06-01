Configuration for using Neovim directly or through VimR on macOS.

## Install

1. Clone this repo into `~/.config/nvim`.
2. Start `nvim` or VimR once to let `lazy.nvim` install plugins.
3. Run `:MasonToolsInstallSync` to install the managed LSP and formatter tools.
4. Restart `nvim` after the first install pass.

## Included Tooling

- Native Neovim LSP for Lua, Python, JSON, YAML, Markdown, and SQL
- `blink.cmp` for completion
- `conform.nvim` for formatting
- `telescope.nvim` for file search and grep

Java and Scala support are intentionally deferred for now.

## Useful Commands

- `:Lazy sync`
- `:Mason`
- `:checkhealth`
- `:Telescope find_files`
