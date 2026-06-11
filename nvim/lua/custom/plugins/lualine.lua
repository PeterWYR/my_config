-- Polished powerline-style statusline
local has_nerd_font = vim.g.have_nerd_font

local function icon(glyph, fallback) return has_nerd_font and glyph or fallback end

local function mode_icon()
  local mode = vim.api.nvim_get_mode().mode
  local icons = {
    n = icon('󰌌', 'N'),
    no = icon('󰌌', 'N'),
    nov = icon('󰌌', 'N'),
    noV = icon('󰌌', 'N'),
    ['no\22'] = icon('󰌌', 'N'),
    niI = icon('󰌌', 'N'),
    niR = icon('󰌌', 'N'),
    niV = icon('󰌌', 'N'),
    nt = icon('󰌌', 'N'),
    v = icon('󰈈', 'V'),
    vs = icon('󰈈', 'V'),
    V = icon('󰈈', 'V'),
    Vs = icon('󰈈', 'V'),
    ['\22'] = icon('󰈈', 'V'),
    ['\22s'] = icon('󰈈', 'V'),
    s = icon('󰒉', 'S'),
    S = icon('󰒉', 'S'),
    ['\19'] = icon('󰒉', 'S'),
    i = icon('󰏫', 'I'),
    ic = icon('󰏫', 'I'),
    ix = icon('󰏫', 'I'),
    R = icon('󰛔', 'R'),
    Rc = icon('󰛔', 'R'),
    Rx = icon('󰛔', 'R'),
    Rv = icon('󰛔', 'R'),
    Rvc = icon('󰛔', 'R'),
    Rvx = icon('󰛔', 'R'),
    c = icon('󰞷', 'C'),
    cv = icon('󰞷', 'C'),
    ce = icon('󰞷', 'C'),
    r = icon('󰑊', 'R'),
    rm = icon('󰑊', 'R'),
    ['r?'] = icon('󰑊', 'R'),
    ['!'] = icon('󰞷', '!'),
    t = icon('󰆍', 'T'),
  }

  return icons[mode] or icon('󰌌', mode:upper())
end

local function macro_recording()
  local register = vim.fn.reg_recording()
  if register == '' then return '' end

  return icon('󰑋', 'REC') .. ' @' .. register
end

local function lsp_clients()
  local clients
  if vim.lsp.get_clients then
    clients = vim.lsp.get_clients { bufnr = 0 }
  else
    clients = vim.lsp.get_active_clients { bufnr = 0 }
  end

  if not clients or #clients == 0 then return '' end

  local names = {}
  for _, client in ipairs(clients) do
    names[#names + 1] = client.name
  end
  table.sort(names)

  if #names > 2 then return icon('󰒋', 'LSP') .. ' ' .. names[1] .. ', ' .. names[2] .. ' +' .. (#names - 2) end

  return icon('󰒋', 'LSP') .. ' ' .. table.concat(names, ', ')
end

local function hide_utf8() return vim.bo.fileencoding ~= '' and vim.bo.fileencoding ~= 'utf-8' end

local function hide_unix() return vim.bo.fileformat ~= 'unix' end

local colors = {
  base = '#191724',
  surface = '#1f1d2e',
  muted = '#6e6a86',
  subtle = '#908caa',
  text = '#e0def4',
  love = '#eb6f92',
  gold = '#f6c177',
  rose = '#ebbcba',
  foam = '#9ccfd8',
  iris = '#c4a7e7',
}

local theme = {
  normal = {
    a = { fg = colors.base, bg = colors.iris, gui = 'bold' },
    b = { fg = colors.iris, bg = colors.surface },
    c = { fg = colors.text, bg = colors.base },
  },
  insert = {
    a = { fg = colors.base, bg = colors.foam, gui = 'bold' },
    b = { fg = colors.foam, bg = colors.surface },
    c = { fg = colors.text, bg = colors.base },
  },
  visual = {
    a = { fg = colors.base, bg = colors.rose, gui = 'bold' },
    b = { fg = colors.rose, bg = colors.surface },
    c = { fg = colors.text, bg = colors.base },
  },
  replace = {
    a = { fg = colors.base, bg = colors.love, gui = 'bold' },
    b = { fg = colors.love, bg = colors.surface },
    c = { fg = colors.text, bg = colors.base },
  },
  command = {
    a = { fg = colors.base, bg = colors.gold, gui = 'bold' },
    b = { fg = colors.gold, bg = colors.surface },
    c = { fg = colors.text, bg = colors.base },
  },
  inactive = {
    a = { fg = colors.subtle, bg = colors.surface, gui = 'bold' },
    b = { fg = colors.subtle, bg = colors.surface },
    c = { fg = colors.muted, bg = colors.base },
  },
}

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  opts = {
    options = {
      theme = theme,
      icons_enabled = vim.g.have_nerd_font,
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' },
      globalstatus = true,
      disabled_filetypes = {
        statusline = { 'dashboard', 'lazy', 'neo-tree', 'NvimTree', 'Trouble' },
      },
    },
    sections = {
      lualine_a = {
        {
          'mode',
          fmt = function(mode) return mode_icon() .. ' ' .. mode end,
        },
      },
      lualine_b = {
        { 'branch', icon = icon('', 'git') },
        {
          'diff',
          symbols = {
            added = icon(' ', '+'),
            modified = icon(' ', '~'),
            removed = icon(' ', '-'),
          },
        },
      },
      lualine_c = {
        {
          'filename',
          path = 1,
          file_status = true,
          newfile_status = true,
          symbols = {
            modified = icon(' ●', ' *'),
            readonly = icon(' 󰌾', ' RO'),
            unnamed = '[No Name]',
            newfile = icon(' 󰎔', ' new'),
          },
        },
        {
          macro_recording,
          color = { fg = colors.love, gui = 'bold' },
        },
      },
      lualine_x = {
        {
          'diagnostics',
          sources = { 'nvim_diagnostic' },
          symbols = {
            error = icon(' ', 'E:'),
            warn = icon(' ', 'W:'),
            info = icon(' ', 'I:'),
            hint = icon('󰌵 ', 'H:'),
          },
        },
        {
          lsp_clients,
          color = { fg = colors.foam },
        },
        { 'encoding', cond = hide_utf8 },
        { 'fileformat', cond = hide_unix },
        { 'filetype', icon_only = false },
      },
      lualine_y = {
        { 'progress', icon = icon('󰦨', '%') },
      },
      lualine_z = {
        { 'location', icon = icon('󰍒', 'Ln') },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
  },
}
