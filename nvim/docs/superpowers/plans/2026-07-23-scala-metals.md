# Scala Metals Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give Scala, sbt, and Scala CLI buffers full Metals language intelligence and Blink completion.

**Architecture:** Install the official `nvim-metals` extension with `vim.pack`, configure it after `blink.cmp`, and initialize one Metals client from a `FileType` autocmd. Keep Metals out of the Mason-managed server table to prevent duplicate clients.

**Tech Stack:** Neovim 0.12, `vim.pack`, `nvim-metals`, Coursier, Metals, `blink.cmp`

## Global Constraints

- Support both sbt projects and Scala CLI projects.
- Reuse the existing generic `LspAttach` mappings.
- Pass Blink completion capabilities to Metals.
- Do not add Metals to Mason or start a second Metals client through `nvim-lspconfig`.

---

### Task 1: Configure and verify nvim-metals

**Files:**
- Modify: `init.lua`
- Test: headless Neovim commands using a temporary Scala buffer

**Interfaces:**
- Consumes: `require('blink.cmp').get_lsp_capabilities()` and the installed `cs` executable.
- Produces: a `FileType` autocmd for `scala`, `sbt`, and `java`, plus buffer-local Metals maintenance mappings.

- [x] **Step 1: Run the failing configuration test**

```sh
nvim --headless \
  '+lua assert(pcall(require, "metals"), "nvim-metals is unavailable")' \
  '+qa!'
```

Expected: failure because `nvim-metals` is not installed.

- [x] **Step 2: Add the plugin and configuration**

```lua
vim.pack.add {
  gh 'nvim-lua/plenary.nvim',
  gh 'scalameta/nvim-metals',
}

local metals_config = require('metals').bare_config()
metals_config.capabilities = require('blink.cmp').get_lsp_capabilities()

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'scala', 'sbt', 'java' },
  callback = function(event)
    vim.keymap.set('n', '<leader>mi', '<cmd>MetalsImportBuild<CR>', { buffer = event.buf })
    vim.keymap.set('n', '<leader>mr', '<cmd>MetalsRestartMetals<CR>', { buffer = event.buf })
    vim.keymap.set('n', '<leader>md', '<cmd>MetalsRunDoctor<CR>', { buffer = event.buf })
    require('metals').initialize_or_attach(metals_config)
  end,
})
```

- [x] **Step 3: Verify the structural configuration**

Run headless Neovim with a Scala buffer and assert that the Metals autocmd, mappings, and Blink snippet capability are present.

- [x] **Step 4: Verify a real Metals client**

Open a temporary Scala CLI source, wait for Metals to attach, and assert that the client advertises `completionProvider`.

- [x] **Step 5: Run final checks**

```sh
git diff --check
nvim --headless '+qa!'
```

Expected: both commands exit successfully.
