# AGENTS.md

## Purpose

This repository is a personal Neovim configuration for macOS, used both in terminal `nvim` and in VimR.

If you are an agent setting this up on a new machine, prefer making minimal changes and keep the config runnable after every edit.

## Target Environment

- macOS
- Neovim `0.12.x` or newer
- VimR support is expected
- Git-based plugin management through `lazy.nvim`
- Local config path should be `~/.config/nvim`

## Repository Layout

- `init.vim` loads `lua/config`
- `lua/config/options.lua` contains editor options and environment setup
- `lua/config/autocmds.lua` contains startup and filetype autocmds
- `lua/config/lazy.lua` bootstraps `lazy.nvim`
- `lua/plugins/lsp.lua` contains treesitter, LSP, formatting, Mason, and `blink.cmp`
- `lazy-lock.json` pins plugin revisions

## Setup Workflow On A New Machine

1. Clone this repository to `~/.config/nvim`
2. Install Neovim `0.12.x` or newer
3. Install Rust with `rustup`
4. Open `nvim` once to let `lazy.nvim` install plugins
5. Run `:Lazy sync`
6. Run `:Lazy build blink.cmp`
7. Run `:MasonToolsInstallSync`
8. Restart `nvim` or VimR
9. Run `:checkhealth`

## Required External Dependencies

### Required

- `git`
- `nvim`
- Rust toolchain with `cargo`

### Expected By Current Config

- `prettier`
- `stylua`
- `ruff`
- `sql-formatter`

These are managed through Mason where applicable, but `cargo` must exist on the machine for `blink.cmp`'s Rust matcher build.

## Important Config Assumptions

### blink.cmp

- The config is intentionally set to use the Rust fuzzy matcher
- `lua/plugins/lsp.lua` contains:
  - `build = function() require("blink.cmp").build():pwait() end`
  - `fuzzy = { implementation = "rust" }`
- If `cargo` is missing, `blink.cmp` native build will fail

### VimR PATH Quirk

GUI apps on macOS may not inherit shell PATH correctly.

This config compensates by prepending `~/.cargo/bin` to `vim.env.PATH` inside `lua/config/options.lua` when the directory exists.

If `blink.cmp` works in terminal Neovim but fails in VimR, check that this PATH logic is still present.

### Weekly Auto-Update

`lua/config/autocmds.lua` contains a `VeryLazy` autocmd that runs `lazy.manage.update({ show = false })` approximately once every 7 days.

It stores the last update timestamp under:

- `stdpath("state")/lazy/auto-update.json`

`lua/config/lazy.lua` also keeps the checker enabled but disables popup notifications:

- `checker = { enabled = true, notify = false }`

## Verification Checklist

After setup, verify all of the following:

- `nvim --version` shows `0.12.x` or newer
- `cargo --version` works
- `nvim --headless '+qa'` exits cleanly
- Opening `nvim` does not show `blink.cmp` build errors
- `:checkhealth` shows no critical failures
- Insert mode completion works
- VimR can start without missing-`cargo` issues

## Safe Recovery Steps

If setup is broken on a new machine, try these in order:

1. Confirm repo is actually located at `~/.config/nvim`
2. Confirm `cargo --version` works
3. Run `:Lazy sync`
4. Run `:Lazy build blink.cmp`
5. Run `:MasonToolsInstallSync`
6. Restart Neovim or VimR
7. Re-run `:checkhealth`

## Git Hygiene

- Keep `lazy-lock.json` in sync with intentional plugin updates
- Do not update plugin pins casually unless you also verify startup still works
- Prefer small focused commits
- If modifying setup behavior, update both `README.md` and this file when relevant

## Notes For Future Agents

- This setup was recently updated to use Rust-backed `blink.cmp`
- The machine bootstrap is expected to support both terminal Neovim and VimR
- If you change completion, plugin bootstrapping, or startup update behavior, verify both entrypoints again
