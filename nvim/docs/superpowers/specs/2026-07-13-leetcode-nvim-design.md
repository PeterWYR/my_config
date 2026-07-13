# leetcode.nvim Integration Design

## Goal

Install `kawre/leetcode.nvim` in the existing lazy.nvim configuration so NeetCode can remain the study-roadmap entry point while coding, testing, and submitting matching problems through `leetcode.cn` in Neovim.

## Configuration

- Add one isolated plugin spec at `lua/custom/plugins/leetcode.lua`.
- Lazy-load the plugin through the `:Leet` command and a `<leader>lc` dashboard mapping.
- Use `leetcode.cn`, with translation and translated problem statements enabled.
- Use `python3` as the initial language. Keep the plugin's native `:Leet lang` picker available for switching a question to C++, Java, Go, or Rust.
- Enable non-standalone mode so the dashboard can be opened from a normal editing session.
- Use the existing Telescope installation as the picker.
- Declare `plenary.nvim` and `nui.nvim` dependencies explicitly.
- Update the Treesitter HTML parser during installation for formatted problem descriptions.

## User Workflow

1. Choose a problem from the NeetCode roadmap.
2. Open the plugin with `<leader>lc` or `:Leet` and search for the matching LeetCode problem.
3. Solve it in Python 3 by default, or run `:Leet lang` to select C++, Java, Go, or Rust.
4. Use the plugin's native run and submit actions.

NeetCode is not treated as a data provider because leetcode.nvim supports only the LeetCode international and China APIs.

## Failure Handling

- Authentication remains in the plugin's native cookie prompt; no credentials are stored in this repository.
- Lazy-loading keeps plugin failures out of normal Neovim startup.
- Existing plugin and lockfile changes are preserved; only the new plugin spec and the lock entry produced by lazy.nvim belong to this integration.

## Verification

- Format and statically load the new Lua plugin spec.
- Run a headless lazy.nvim installation/sync so dependencies and the plugin are resolved.
- Start Neovim headlessly and verify the `:Leet` command exists after loading.
- Confirm the generated lockfile contains `leetcode.nvim` without overwriting unrelated user changes.
