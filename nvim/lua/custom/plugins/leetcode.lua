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
