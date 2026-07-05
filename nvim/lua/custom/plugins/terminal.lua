---@module 'lazy'
---@type LazySpec
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    { [[<C-\>]], mode = { 'n', 'i', 't' }, desc = 'Toggle terminal' },
    { '<leader>tt', '<cmd>ToggleTerm direction=horizontal<CR>', desc = '[T]erminal [T]oggle' },
    { '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', desc = '[T]erminal [F]loat' },
    { '<leader>tv', '<cmd>ToggleTerm direction=vertical<CR>', desc = '[T]erminal [V]ertical' },
  },
  cmd = {
    'ToggleTerm',
    'TermExec',
  },
  opts = {
    open_mapping = [[<C-\>]],
    direction = 'float',
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    close_on_exit = true,
    shade_terminals = true,
    float_opts = {
      border = 'curved',
      width = function() return math.floor(vim.o.columns * 0.9) end,
      height = function() return math.floor(vim.o.lines * 0.8) end,
    },
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)
  end,
}
