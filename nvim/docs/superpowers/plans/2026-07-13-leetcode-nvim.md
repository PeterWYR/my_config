# leetcode.nvim Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Install and configure `kawre/leetcode.nvim` for a NeetCode-guided, `leetcode.cn`-backed workflow with Python 3 as the default and native switching to C++, Java, Go, and Rust.

**Architecture:** Add a single focused lazy.nvim plugin spec under the existing `custom.plugins` import. Load it only through the `:Leet` command or `<leader>lc`, reuse Telescope and existing shared dependencies, and let lazy.nvim record only the new plugin lock entry.

**Tech Stack:** Neovim 0.12.4, Lua, lazy.nvim, leetcode.nvim, Telescope, plenary.nvim, nui.nvim, nvim-treesitter

## Global Constraints

- Connect to `leetcode.cn`; do not attempt a NeetCode API integration.
- Default to `python3`; use native `:Leet lang` for C++, Java, Go, and Rust.
- Enable non-standalone mode so `:Leet` works from an ordinary editing session.
- Preserve all pre-existing uncommitted changes in `init.lua`, `lazy-lock.json`, and unrelated files.
- Store no authentication cookies or credentials in the repository.

---

### Task 1: Add and install the leetcode.nvim plugin spec

**Files:**
- Create: `lua/custom/plugins/leetcode.lua`
- Modify: `lazy-lock.json` (only the lazy.nvim-generated `leetcode.nvim` entry)

**Interfaces:**
- Consumes: the existing `{ import = 'custom.plugins' }` declaration, Telescope installation, and lazy.nvim dependency resolution.
- Produces: the `:Leet` user command, `<leader>lc` mapping, and a configured `require('leetcode')` module after lazy-loading.

- [ ] **Step 1: Record the existing lockfile diff before installation**

Run: `git diff -- lazy-lock.json`

Expected: existing user changes may be present; retain them byte-for-byte except for the added `leetcode.nvim` entry.

- [ ] **Step 2: Verify the command is absent before adding the plugin**

Run:

```bash
nvim --headless "+lua assert(vim.fn.exists(':Leet') == 0, ':Leet unexpectedly exists')" +qa
```

Expected: exit status 0, confirming the current configuration does not define `:Leet`.

- [ ] **Step 3: Create the lazy.nvim plugin spec**

Create `lua/custom/plugins/leetcode.lua` with exactly:

```lua
---@module 'lazy'
---@type LazySpec
return {
  'kawre/leetcode.nvim',
  cmd = 'Leet',
  keys = {
    { '<leader>lc', '<cmd>Leet<CR>', desc = '[L]eet[C]ode' },
  },
  build = ':TSUpdate html',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  opts = {
    lang = 'python3',
    cn = {
      enabled = true,
      translator = true,
      translate_problems = true,
    },
    plugins = {
      non_standalone = true,
    },
    picker = {
      provider = 'telescope',
    },
  },
}
```

- [ ] **Step 4: Check formatting and Lua syntax**

Run:

```bash
stylua --check lua/custom/plugins/leetcode.lua
luac -p lua/custom/plugins/leetcode.lua
```

Expected: both commands exit 0 without output. If `luac` is unavailable, use `nvim --clean --headless "+lua assert(loadfile('lua/custom/plugins/leetcode.lua'))" +qa` and expect exit status 0.

- [ ] **Step 5: Install the plugin and update its lock entry**

Run:

```bash
nvim --headless "+Lazy! sync leetcode.nvim" +qa
```

Expected: lazy.nvim clones `leetcode.nvim`, resolves its declared dependencies, updates the HTML Treesitter parser, and exits successfully.

- [ ] **Step 6: Verify lazy-loading and configuration**

Run:

```bash
nvim --headless "+lua assert(vim.fn.exists(':Leet') == 2, ':Leet command missing'); local spec = require('lazy.core.config').plugins['leetcode.nvim']; assert(spec, 'lazy spec missing'); assert(spec._.loaded == nil, 'plugin loaded before command')" "+lua require('lazy').load({ plugins = { 'leetcode.nvim' } }); local cfg = require('leetcode.config').user; assert(cfg.lang == 'python3'); assert(cfg.cn.enabled == true); assert(cfg.plugins.non_standalone == true); assert(cfg.picker.provider == 'telescope')" +qa
```

Expected: exit status 0 with no assertion failures.

- [ ] **Step 7: Confirm the lockfile change is scoped**

Run:

```bash
git diff -- lazy-lock.json
rg -n '"leetcode.nvim"' lazy-lock.json
git diff --check -- lua/custom/plugins/leetcode.lua lazy-lock.json
```

Expected: `leetcode.nvim` appears exactly once; the pre-existing lockfile diff remains intact; `git diff --check` exits 0.

- [ ] **Step 8: Commit only the integration files**

```bash
git add lua/custom/plugins/leetcode.lua lazy-lock.json
git commit -m "feat: add leetcode.nvim"
```

Expected: the commit contains the plugin spec and current lockfile. Review the staged diff first if `lazy-lock.json` contains unrelated user changes; in that case, commit only `lua/custom/plugins/leetcode.lua` and leave the lockfile uncommitted rather than claiming unrelated edits.
