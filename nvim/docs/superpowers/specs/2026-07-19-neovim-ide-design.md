# Neovim IDE Configuration Design

## Goal

Build a readable, maintainable Neovim 0.12 configuration from scratch. It must provide VS Code-class coding support without importing a Neovim distribution.

## Architecture

The configuration is split by capability. `lua/config/` owns editor behavior, keymaps, autocommands, Lazy bootstrap, and one shared language matrix. `lua/plugins/` owns plugin specifications grouped by UI, navigation, editing, completion, language tooling, formatting, debugging, testing, and tools.

`init.lua` only loads the core modules. Plugin loading is explicit through Lazy events, commands, filetypes, and keys. `lazy-lock.json` is committed for reproducible plugin versions.

## User Interface

- Use Rose Pine Main with Nerd Font icons.
- Use Lualine for mode, Git, diagnostics, filename, LSP status, filetype, progress, and location.
- Use Bufferline for VS Code-style open-file tabs.
- Use Neo-tree for files, buffers, and Git status.
- Use Telescope with native FZF for file, text, symbol, diagnostic, command, and keymap search.
- Use Which-key for discoverable Space-leader groups.
- Use Trouble for diagnostic and reference lists and Aerial for symbols.

## Editing

- Use Blink v1 for non-AI completion from LSP, visible buffers, paths, and snippets.
- Use Super Tab: accept completion, move through snippet placeholders, then fall back to a literal Tab.
- Highlight matched completion text and show source, kind, and documentation.
- Use native `vim.snippet` with friendly-snippets.
- Use nvim-autopairs for brackets and quotes.
- Use nvim-ts-autotag for HTML, JSX, and Vue tag closing and renaming.
- Use mini.ai, mini.surround, guess-indent, and native comments.
- Never format automatically on save. Formatting is manual through `<leader>cf`.

## Language Support

| Stack | LSP | Formatting and diagnostics | Debugging and tests |
| --- | --- | --- | --- |
| TypeScript, JavaScript, React, Vue | vtsls, vue_ls, html, cssls, jsonls, tailwindcss, eslint | prettierd, ESLint | js-debug, Jest, Vitest |
| Python | basedpyright, ruff | Ruff | debugpy, pytest |
| Go | gopls | gofumpt, goimports, golangci-lint | Delve, go test |
| Rust | rust-analyzer | rustfmt, Clippy | codelldb, cargo test |
| C and C++ | clangd | clang-format, clang-tidy | codelldb, CTest tasks |
| Lua | lua_ls, lazydev | stylua | Busted tasks |
| Shell | bashls | shfmt, shellcheck | bash-debug, Bats tasks |
| Markdown | marksman | prettier, markdownlint-cli2 | Not applicable |

Neovim 0.12 native `vim.lsp.config()` and `vim.lsp.enable()` APIs are mandatory. The deprecated `require("lspconfig").setup()` API must not be used. Treesitter uses its current main-branch API.

## IDE Features

- Gitsigns and Lazygit provide line and repository Git workflows.
- nvim-dap, nvim-dap-ui, and virtual text provide debugging.
- Neotest provides supported test adapters; Overseer runs project-specific test and build commands.
- ToggleTerm provides project terminals.
- Persistence restores project sessions.
- Space-leader groups are `f` files, `s` search, `b` buffers, `g` Git, `c` code, `d` debug, `t` tests, `r` tasks, `x` diagnostics, and `u` UI toggles.
- User keymaps remain centralized in `lua/config/keymaps.lua`.

## Reliability

Network bootstrap failures must be explicit. Existing plugin caches should still allow offline startup. Plugin errors must name the failing plugin or tool. README documentation covers dependencies, installation, keymaps, language extension, updates, and rollback.

Verification includes Lua formatting, headless startup, smoke assertions, health checks, one project per language family, UI checks, and startup profiling. Target cold startup is approximately 150 ms without deleting required functionality.
