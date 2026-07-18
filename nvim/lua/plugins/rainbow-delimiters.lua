---@type LazySpec
return {
  "HiPhish/rainbow-delimiters.nvim",
  event = { "BufReadPost", "BufNewFile" },
  init = function()
    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = "rainbow-delimiters.strategy.global",
      },
      query = {
        [""] = "rainbow-delimiters",
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
    }
  end,
  config = function()
    local colors = {
      red = "#c45a78",
      yellow = "#c49a5a",
      blue = "#42778b",
      orange = "#c7857f",
      green = "#5d9298",
      violet = "#9a7db8",
      cyan = "#5c8695",
    }

    vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = colors.red })
    vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = colors.yellow })
    vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = colors.orange })
    vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = colors.green })
    vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = colors.violet })
    vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = colors.cyan })

    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("rainbow_delimiters_parser_updates", { clear = true }),
      pattern = "TSUpdate",
      desc = "Reattach rainbow delimiters after Tree-sitter parser updates",
      callback = function()
        local rainbow = require "rainbow-delimiters.lib"

        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype ~= "" then rainbow.attach(bufnr) end
        end
      end,
    })
  end,
}
