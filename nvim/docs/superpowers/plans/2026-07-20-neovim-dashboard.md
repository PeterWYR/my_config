# Neovim Dashboard Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an Alpha dashboard with a Rose Pine-styled `NEOVIM` ASCII header and useful startup actions.

**Architecture:** Keep dashboard configuration in a focused `lua/plugins/dashboard.lua` spec. Alpha will own the startup buffer and local button mappings, while button actions call the existing Telescope and persistence workflows. The existing global leader mappings, Lualine, and Bufferline remain unchanged.

**Tech Stack:** Neovim 0.12.4, Lua, lazy.nvim, `goolord/alpha-nvim`, Telescope, persistence.nvim, nvim-web-devicons, Rose Pine.

## Global Constraints

- Use `goolord/alpha-nvim`.
- Reuse the existing `nvim-tree/nvim-web-devicons` dependency.
- Show the dashboard only for an empty Neovim startup; do not replace an explicitly opened file.
- Keep existing global mappings intact.
- Preserve the existing Rose Pine, Lualine, and Bufferline configuration.

---

### Task 1: Add dashboard registration and configuration tests

**Files:**
- Modify: `tests/plugins.lua`
- Create: `tests/dashboard.lua`

**Interfaces:**
- Produces assertions that the Alpha plugin is registered on `VimEnter`, reuses web-devicons, and exposes the intended dashboard sections.

- [ ] **Step 1: Add Alpha to the plugin registry expectations**

In `tests/plugins.lua`, add `"alpha-nvim"` to `expected_plugins` immediately after `"aerial.nvim"`.

- [ ] **Step 2: Create the focused dashboard spec test**

Create `tests/dashboard.lua`:

```lua
local assert = dofile("tests/assertions.lua")

local specs = dofile("lua/plugins/dashboard.lua")
local dashboard

for _, spec in ipairs(specs) do
  if spec[1] == "goolord/alpha-nvim" then
    dashboard = spec
    break
  end
end

assert.truthy(dashboard, "Alpha dashboard registered")
assert.equal(dashboard.event, "VimEnter", "Alpha loads on VimEnter")
assert.truthy(dashboard.dependencies, "Alpha has dependencies")

local has_devicons = false
for _, dependency in ipairs(dashboard.dependencies) do
  if dependency == "nvim-tree/nvim-web-devicons" then
    has_devicons = true
  end
end
assert.truthy(has_devicons, "Alpha reuses nvim-web-devicons")

local handle = assert(io.open("lua/plugins/dashboard.lua", "r"), "dashboard source readable")
local source = handle:read("*a")
handle:close()
assert.truthy(source:find("███╗   ██╗", 1, true), "dashboard contains NEOVIM ASCII header")
assert.truthy(source:find("Telescope find_files", 1, true), "dashboard contains file search action")
assert.truthy(source:find("persistence", 1, true), "dashboard contains session action")

print("dashboard assertions: ok")
```

- [ ] **Step 3: Run the new test and verify it fails for the missing plugin spec**

Run:

```bash
state_dir="$(mktemp -d /tmp/nvim-state.XXXXXX)"
XDG_STATE_HOME="$state_dir" nvim --headless -u NONE -l tests/dashboard.lua +qa
```

Expected: FAIL because `lua/plugins/dashboard.lua` does not exist yet.

### Task 2: Implement the Alpha dashboard

**Files:**
- Create: `lua/plugins/dashboard.lua`

**Interfaces:**
- Consumes: Telescope commands and `require("persistence").load()` from existing plugins.
- Produces: A lazy.nvim plugin spec for `goolord/alpha-nvim` with a custom dashboard layout.

- [ ] **Step 1: Add the minimal Alpha plugin spec**

Create `lua/plugins/dashboard.lua`:

```lua
local header = {
  " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
  " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
  " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
  " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
  " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
  " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
}

return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = header
      dashboard.section.header.opts.hl = "Type"
      dashboard.section.buttons.val = {
        dashboard.button("f", "󰱼  Find file", "<cmd>Telescope find_files<CR>"),
        dashboard.button("g", "󰺮  Live grep", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("r", "󰄉  Recent files", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("s", "󰁯  Restore session", "<cmd>lua require('persistence').load()<CR>"),
        dashboard.button("q", "󰅚  Quit", "<cmd>qa<CR>"),
      }
      dashboard.section.footer.val = "Enjoy your editing"

      alpha.setup(dashboard.config)
    end,
  },
}
```

- [ ] **Step 2: Run the focused test and verify it passes**

Run:

```bash
state_dir="$(mktemp -d /tmp/nvim-state.XXXXXX)"
XDG_STATE_HOME="$state_dir" nvim --headless -u NONE -l tests/dashboard.lua +qa
```

Expected: `dashboard assertions: ok`.

### Task 3: Install, lock, and verify the dashboard

**Files:**
- Modify: `lazy-lock.json`
- Verify: `lua/plugins/dashboard.lua`, `tests/plugins.lua`, `tests/dashboard.lua`

**Interfaces:**
- Consumes: The Alpha plugin spec from Task 2.
- Produces: An installed and reproducibly locked Alpha version.

- [ ] **Step 1: Install Alpha and update only its lock entry**

Run:

```bash
nvim --headless -u init.lua '+Lazy! install alpha-nvim' +qa
```

Confirm that `lazy-lock.json` contains an `alpha-nvim` entry and that unrelated lock entries are unchanged.

- [ ] **Step 2: Verify headless startup without a file argument**

Run:

```bash
state_dir="$(mktemp -d /tmp/nvim-state.XXXXXX)"
XDG_STATE_HOME="$state_dir" nvim --headless -u init.lua +'lua print("dashboard_startup_ok")' +qa
```

Expected: `dashboard_startup_ok` and no Alpha error.

- [ ] **Step 3: Verify existing tests**

Run:

```bash
state_dir="$(mktemp -d /tmp/nvim-state.XXXXXX)"
XDG_STATE_HOME="$state_dir" nvim --headless -u init.lua \
  -l tests/core.lua \
  -l tests/plugins.lua \
  -l tests/dashboard.lua \
  -l tests/languages.lua \
  -l tests/workflows.lua \
  -l tests/lsp_runtime.lua \
  -l tests/formatting.lua \
  -l tests/completion.lua +qa
```

Expected: exit code 0 and all assertion scripts pass.

- [ ] **Step 4: Check the final diff**

Run:

```bash
git diff --check
git status --short
```

Expected: only the dashboard implementation/test files and the Alpha lock entry are changed, aside from the existing Telescope changes.
