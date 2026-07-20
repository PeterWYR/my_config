# Neovim Dashboard Design

## Goal

Add a startup dashboard to the Neovim configuration using `goolord/alpha-nvim`. The dashboard should present a Rose Pine-styled ASCII `NEOVIM` header and provide useful entry points without changing the existing leader-key workflows.

## Design

- Install `goolord/alpha-nvim` through `lazy.nvim`.
- Reuse the existing `nvim-web-devicons` dependency instead of adding another icon provider.
- Load the dashboard on `VimEnter` only when Neovim starts without an explicit file or command argument.
- Use a custom Alpha layout with:
  - centered `NEOVIM` ASCII header;
  - Find File and Live Grep actions backed by Telescope;
  - Recent Files backed by Telescope;
  - Restore Session backed by `persistence.nvim`;
  - a quit action.
- Use existing Rose Pine highlight groups and keep Lualine/Bufferline behavior unchanged.
- Keep existing global mappings intact; dashboard buttons use local mappings only.

## Files

- Add `lua/plugins/dashboard.lua` for the plugin specification and Alpha setup.
- Update `lazy-lock.json` with the resolved Alpha commit.

## Validation

- Headless Neovim startup succeeds.
- Alpha loads without errors when starting with no file arguments.
- Starting Neovim with a file does not replace the requested buffer with the dashboard.
- Dashboard actions invoke the existing Telescope and persistence workflows.
- Existing configuration tests remain passing.
