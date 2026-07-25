# Neovim Terminal Design

## Goal

Provide two built-in terminal launchers:

- `<leader>tf`: open a fresh terminal in a centered floating window.
- `<leader>tt`: open a fresh terminal in a bottom split similar to VS Code's integrated terminal.

Each invocation starts a new shell process. Terminal working directory resolves from the current file's project root. Resolution checks project marker files while walking upward, then Git root, then Neovim's current working directory.

## Architecture

Add `lua/custom/plugins/terminal.lua` and load it through the existing custom plugin loader. The module owns terminal creation, layout, shell invocation, working-directory resolution, and terminal-local mappings. It uses Neovim's built-in terminal APIs and adds no plugin dependency.

The module exposes two local launcher functions. The float launcher creates a scratch terminal buffer, opens a centered float sized to about 80% of editor width and 70% of editor height, then starts the shell. The split launcher creates a bottom window with a practical fixed height, then starts the shell in that window.

Project markers are `package.json`, `Cargo.toml`, `pyproject.toml`, `go.mod`, `pom.xml`, `build.sbt`, `mix.exs`, `composer.json`, `Gemfile`, `Makefile`, and `CMakeLists.txt`. The closest matching marker while walking upward determines project root. If no marker exists, the closest `.git` entry determines root.

## Behavior

- Terminal buffers use `buftype=terminal` through `termopen()`.
- New terminals start in insert mode.
- Existing `<Esc><Esc>` terminal-mode mapping exits to terminal normal mode.
- Terminal normal mode maps `q` to close its window, ending that terminal session.
- Shell output and process errors remain visible in the terminal buffer.
- Float dimensions are clamped to remain usable in small Neovim windows.

## Integration

`lua/custom/plugins/init.lua` already discovers and requires Lua modules beside itself. Adding `terminal.lua` there keeps terminal configuration separate from the large Kickstart `init.lua` while preserving current plugin-loading behavior.

## Verification

- Start Neovim headlessly to confirm configuration loads without errors.
- Assert both normal-mode keymaps are registered.
- Invoke each launcher with a temporary shell command and verify terminal buffers and their window layouts.
- Run `git diff --check`.
