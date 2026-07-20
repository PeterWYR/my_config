# Neovim IDE Configuration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a from-scratch Neovim 0.12 configuration with VS Code-class coding support and fully user-owned behavior.

**Architecture:** Core editor behavior lives in `lua/config/`; Lazy plugin specifications live in capability-focused files under `lua/plugins/`. A shared language matrix drives Treesitter, Mason, LSP, formatting, linting, debugging, and testing setup.

**Tech Stack:** Lua, Neovim 0.12.4, lazy.nvim, native LSP, Mason, Treesitter, Telescope, Blink, DAP, Neotest, Overseer.

## Global Constraints

- Work directly in `/Users/wangyiran/.config/nvim` on branch `main`, as explicitly approved.
- Do not import LazyVim, NvChad, AstroNvim, or another distribution.
- Use Rose Pine Main and the installed Nerd Font.
- Use `blink.cmp` stable v1 with Super Tab and no AI completion source.
- Never format automatically on save; `<leader>cf` formats manually.
- Use Neovim 0.12 native LSP APIs, never deprecated `require("lspconfig").setup()`.
- Track `lazy-lock.json`.
- Keep user keymaps centralized in `lua/config/keymaps.lua`.
- Support Web, Python, Go, Rust, C/C++, Lua, Shell, and Markdown.

---

### Task 1: Core bootstrap and smoke harness

**Files:** Create `init.lua`, `stylua.toml`, `lua/config/options.lua`, `lua/config/keymaps.lua`, `lua/config/autocmds.lua`, `lua/config/lazy.lua`, `tests/core.lua`, and `tests/assertions.lua`.

- [ ] Write core assertions before implementation.
- [ ] Run `nvim --headless -u init.lua -l tests/core.lua` and verify expected failure from missing core modules.
- [ ] Implement core modules and Lazy bootstrap.
- [ ] Run `nvim --headless "+Lazy! sync" +qa`.
- [ ] Run core assertions and verify success.
- [ ] Commit core bootstrap.

### Task 2: UI, navigation, and editing

**Files:** Create `lua/plugins/ui.lua`, `lua/plugins/navigation.lua`, `lua/plugins/editing.lua`, and `tests/plugins.lua`; update `lua/config/keymaps.lua`.

- [ ] Add failing assertions for required plugin registrations and key groups.
- [ ] Configure Rose Pine, Lualine, Bufferline, Neo-tree, Telescope, Which-key, Gitsigns, Trouble, Aerial, autopairs, ts-autotag, mini modules, and guess-indent.
- [ ] Synchronize plugins and run assertions.
- [ ] Verify UI interactively and commit.

### Task 3: Completion

**Files:** Create `lua/plugins/completion.lua`; update `tests/plugins.lua`.

- [ ] Add failing assertions for Blink and friendly-snippets.
- [ ] Configure Blink v1, native snippets, visible-buffer words, path and LSP sources, match highlighting, documentation, signature help, and Super Tab.
- [ ] Verify completion behavior in Lua and prose buffers.
- [ ] Commit completion support.

### Task 4: Treesitter, Mason, and LSP

**Files:** Create `lua/config/languages.lua`, `lua/plugins/lsp.lua`, and `tests/languages.lua`; update `tests/plugins.lua`.

- [ ] Add failing language-matrix and plugin assertions.
- [ ] Configure current Treesitter API and parser installation.
- [ ] Configure Mason and native LSP for every approved stack.
- [ ] Install tools, run health checks, and run assertions.
- [ ] Commit language intelligence.

### Task 5: Manual formatting and linting

**Files:** Create `lua/plugins/formatting.lua`; update `lua/config/keymaps.lua`, `lua/config/languages.lua`, and tests.

- [ ] Add failing assertions for formatter and linter maps and the manual format key.
- [ ] Configure Conform and nvim-lint without format-on-save.
- [ ] Verify representative files remain unchanged on save and change only after `<leader>cf`.
- [ ] Commit formatting and linting.

### Task 6: Debugging, tests, tasks, terminals, Git, and sessions

**Files:** Create `lua/plugins/debugging.lua`, `lua/plugins/testing.lua`, and `lua/plugins/tools.lua`; update keymaps and tests.

- [ ] Add failing plugin and keymap assertions.
- [ ] Configure DAP adapters and UI.
- [ ] Configure Neotest adapters and Overseer tasks.
- [ ] Configure ToggleTerm, Persistence, and Lazygit.
- [ ] Run smoke tests and interactive checks.
- [ ] Commit IDE workflows.

### Task 7: Documentation and end-to-end verification

**Files:** Create `README.md`; update tests if integration gaps are found.

- [ ] Document prerequisites, installation, keymaps, language extension, updates, and rollback.
- [ ] Run `stylua --check .`.
- [ ] Run all headless smoke tests.
- [ ] Run Lazy, Mason, Treesitter, and LSP health checks.
- [ ] Verify each language family with a minimal project.
- [ ] Profile startup and correct unintended eager loading.
- [ ] Commit README and verification fixes.
