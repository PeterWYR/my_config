return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = { preset = "super-tab" },
      snippets = { preset = "default" },
      completion = {
        menu = {
          draw = {
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
            components = {
              label = {
                highlight = function(ctx)
                  local highlights = {
                    { 0, #ctx.label, group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel" },
                  }

                  if ctx.label_detail then
                    table.insert(
                      highlights,
                      { #ctx.label, #ctx.label + #ctx.label_detail, group = "BlinkCmpLabelDetail" }
                    )
                  end

                  for _, index in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { index, index + 1, group = "BlinkCmpLabelMatch" })
                  end

                  return highlights
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
      },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          buffer = {
            opts = {
              get_bufnrs = function()
                local current = vim.api.nvim_get_current_buf()
                local buffers = { current }
                local seen = { [current] = true }

                for _, window in ipairs(vim.api.nvim_list_wins()) do
                  local buffer = vim.api.nvim_win_get_buf(window)
                  if not seen[buffer] and vim.bo[buffer].buflisted then
                    seen[buffer] = true
                    table.insert(buffers, buffer)
                  end
                end

                return buffers
              end,
            },
          },
        },
      },
    },
    opts_extend = { "sources.default" },
  },
}
