# Neovim Modernization Design

Date: 2026-05-31
Repo: `/Users/sainatha/dotfiles/.config/nvim`

## Summary

Modernize the current Neovim configuration away from Coc and `vim-plug` into a Lua-first configuration built around Neovim's native LSP client, `lazy.nvim`, and a small set of current plugins. Preserve the existing editing feel where it still adds value, keep the setup working in both `nvim` and VimR, and explicitly support Lua, Python, JSON, YAML, Markdown, SQL, Java, and Scala in phase 1.

## Goals

- Remove the dependency on `coc.nvim` and Coc extensions.
- Replace `vim-plug` with `lazy.nvim`.
- Migrate from a mostly monolithic `init.vim` to a maintainable Lua-first config layout.
- Keep the config working in both `nvim` and VimR.
- Provide automatic completion, diagnostics, hover, navigation, formatting, and code actions using Neovim-native tooling.
- Add phase-1 support for Lua, Python, JSON, YAML, Markdown, SQL, Java, and Scala.
- Preserve useful existing behavior such as colorscheme, clipboard integration, relative numbers, split behavior, persistent undo, VimR-specific GUI mappings, and selected editing plugins where they still fit.

## Non-Goals

- Perfect one-to-one recreation of Coc keymaps.
- Turning the config into a full Neovim distribution.
- Adding every language or tool up front.
- Broad refactoring of unrelated editor behavior.

## Current State

The repo is a standalone git repository under `~/.config/nvim`. The current setup is centered on a single `init.vim`, uses `vim-plug`, and includes a substantial Coc block for completion, diagnostics, navigation, formatting, and per-language extensions. The repo also currently has uncommitted local changes, including recent Coc runtime mitigation changes and `autoload/plug.vim` updates.

## Git And Branch Strategy

Before any migration work:

1. Commit the current uncommitted changes on the current branch exactly as they exist.
2. Create a dedicated migration branch from that updated state.
3. Perform the modernization work only on the migration branch.

This preserves the current working state, gives a clean rollback point before removing Coc, and keeps the migration reviewable.

## Target Configuration Shape

The final setup should be Lua-first while keeping `init.vim` as a minimal compatibility entrypoint. `init.vim` should do little more than bootstrap the Lua config so both `nvim` and VimR continue loading the same shared configuration.

Planned layout:

- `init.vim`
  - Thin entrypoint that loads Lua and preserves any Vimscript-only compatibility glue still needed.
- `lua/config/options.lua`
  - Core editor options migrated from `init.vim`.
- `lua/config/keymaps.lua`
  - Global keymaps, favoring current Neovim defaults and a small number of deliberate custom mappings.
- `lua/config/autocmds.lua`
  - Filetype and behavior autocmds migrated from Vimscript where still useful.
- `lua/config/lazy.lua`
  - `lazy.nvim` bootstrap and plugin loader setup.
- `lua/plugins/*.lua`
  - Focused plugin specs grouped by concern, such as LSP, completion, formatting, finder, UI, and editing helpers.

This structure keeps plugin declarations, editor behavior, and language tooling separate, making future changes easier and safer.

## Plugin Strategy

Use a lean, modern plugin stack rather than a full framework:

- Plugin manager: `folke/lazy.nvim`
- LSP wiring: `neovim/nvim-lspconfig`
- Tool installer and registry integration: `mason-org/mason.nvim` and `mason-org/mason-lspconfig.nvim`
- Completion: `saghen/blink.cmp`
- Formatting: `stevearc/conform.nvim`
- Syntax and structure: `nvim-treesitter/nvim-treesitter`
- Finder and discovery: `nvim-telescope/telescope.nvim`
- Keymap discoverability: `folke/which-key.nvim`
- Auto-pairs: `windwp/nvim-autopairs`

Keep these existing non-Coc plugins in the initial migration:

- `vim-surround`
- `undotree`
- `quick-scope`
- `context.vim`
- `nvim-peekup`
- `papercolor-theme`
- `vim-highlightedyank`
- `vim-rooter`
- `org.vim`

Replace these components in the initial migration:

- `ctrlp.vim` with Telescope
- `coc.nvim` and its related settings, commands, extensions, and mappings

Remove these older syntax-oriented helpers in the initial migration because Tree-sitter and native filetype support should own that space:

- `vim-polyglot`
- `vim-yaml`
- `vim-markdown`
- `vim-python-pep8-indent`

## Language Tooling Strategy

Neovim provides the LSP client. Language servers and external formatters are still separate tools and will be managed explicitly.

### Core LSP Pattern

- Use Neovim's built-in LSP client as the common base.
- Use Mason to install and manage supported language servers and formatter binaries.
- Use `nvim-lspconfig` for common server setup.
- Use language-specific integrations where they are the better modern path.

### Phase-1 Language Support

- Lua
  - LSP: `lua_ls`
  - Formatting: `stylua`
  - Special handling: configure Lua workspace support for Neovim runtime and config development.

- Python
  - LSP: `pyright`
  - Formatting and linting: `ruff`, used as the default Python formatter and linter in phase 1.

- JSON
  - LSP: `jsonls`
  - Installed through Mason using the current `jsonls` mapping.

- YAML
  - LSP: `yamlls`
  - Enable schema-aware behavior in phase 1.

- Markdown
  - LSP: `marksman`
  - Linting/formatting: keep markdown linting support via dedicated tooling rather than Coc.

- SQL
  - LSP: `sqls`
  - Use a lightweight default setup in phase 1.

- Java
  - Use `eclipse.jdt.ls` for the server.
  - Use `mfussenegger/nvim-jdtls` rather than a bare generic LSP setup so Java gets the integrations it typically needs.
  - Treat Java as phase 1, not a follow-up.

- Scala
  - Use Metals for the language server.
  - Use `scalameta/nvim-metals` for the Neovim integration rather than forcing Scala into a generic LSP-only path.
  - Treat Scala as phase 1, not a follow-up.

## Expected User Experience

The config should feel automatic in the same broad way Coc did, without requiring Coc's extension model:

- Completion should appear naturally while editing.
- Hover, definition, references, rename, diagnostics, and code actions should work through standard LSP features.
- Formatting should work consistently through `conform.nvim`, with format-on-save enabled for the phase-1 filetypes supported by the configured formatter set.
- Telescope should become the default surface for file search, grep, buffers, symbols, and LSP-driven discovery.
- Diagnostics should be visible inline and in the sign column without disruptive noise.
- The setup should start cleanly without manual post-launch repair steps.

Because the user does not rely heavily on Coc-specific keybindings, the migration should prefer sane modern defaults over a strict keymap translation exercise.

## Preserved Behavior

Preserve or port these behaviors unless testing shows they conflict with the new stack:

- VimR-specific GUI mappings behind `has("gui_vimr")`
- Shared clipboard integration
- Relative line numbers
- Search behavior
- Split direction preferences
- Persistent undo, swap, backup, and view directories
- Mouse support
- Theme choice and general visual feel
- The explicitly retained convenience plugins listed in the plugin strategy section

## Migration Plan

1. Commit the current dirty state on the current branch.
2. Create a migration branch from that commit.
3. Bootstrap `lazy.nvim`.
4. Introduce the Lua config structure while keeping `init.vim` as the entrypoint.
5. Port general options, keymaps, and autocmds from Vimscript into Lua.
6. Install and configure the core plugin stack.
7. Add native LSP, completion, formatting, and Tree-sitter behavior.
8. Add phase-1 language integrations for Lua, Python, JSON, YAML, Markdown, SQL, Java, and Scala.
9. Replace `ctrlp.vim` workflows with Telescope.
10. Remove Coc-specific config, commands, mappings, and dependencies.
11. Remove `vim-plug` bootstrap and old plugin declarations once the new setup is verified.

## Verification Strategy

Verification should combine startup checks, plugin health checks, and real-file testing:

- `nvim --headless` should start without config errors.
- Relevant health checks should pass for LSP, Treesitter, Mason, and installed tools.
- Representative files should be opened for each phase-1 language.
- Confirm completion, diagnostics, hover, go-to-definition, references, rename, and formatting all work in at least a basic project for each major language family.
- Confirm Java and Scala attach through their dedicated integrations rather than a generic fallback.
- Confirm VimR still loads the Neovim config and preserves GUI-specific mappings.

## Risks And Mitigations

- Java setup complexity
  - Mitigation: use `nvim-jdtls` from the start instead of trying to flatten Java into a generic LSP path.

- Scala setup complexity
  - Mitigation: use `nvim-metals` from the start instead of a generic LSP path.

- Old Vimscript assumptions leaking into the new config
  - Mitigation: port behavior intentionally and verify each preserved feature rather than bulk-copying logic.

- Finder workflow change from CtrlP to Telescope
  - Mitigation: add a small, memorable default mapping set and verify file/buffer/grep flows early.

- Plugin churn from old syntax plugins
  - Mitigation: keep the initial plugin surface small and remove old syntax helpers only after Tree-sitter and native filetypes are confirmed to cover the workflow.

## Implementation Notes

- Favor a small number of well-supported plugins over a broad plugin collection.
- Keep Java and Scala as first-class exceptions where language-specific integrations are the modern best path.
- Avoid recreating Coc behavior through fragile compatibility shims.
- Prefer readability and maintainability over clever abstractions in the new Lua config.
