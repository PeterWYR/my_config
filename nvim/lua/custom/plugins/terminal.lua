local project_markers = {
  'package.json',
  'Cargo.toml',
  'pyproject.toml',
  'go.mod',
  'pom.xml',
  'build.sbt',
  'mix.exs',
  'composer.json',
  'Gemfile',
  'Makefile',
  'CMakeLists.txt',
}

local function terminal_cwd()
  local name = vim.api.nvim_buf_get_name(0)
  local start = name == '' and vim.fn.getcwd() or vim.fn.fnamemodify(name, ':p:h')
  local marker = vim.fs.find(project_markers, { path = start, upward = true, type = 'file' })[1]
  if marker then return vim.fs.dirname(marker) end

  local git = vim.fs.find('.git', { path = start, upward = true })[1]
  if git then return vim.fs.dirname(git) end

  return vim.fn.getcwd()
end

local function close_terminal(buf, win)
  if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
  if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
end

local function open_terminal(layout)
  local cwd = terminal_cwd()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.max(1, math.floor(vim.o.columns * 0.8))
  local height = math.max(1, math.floor(vim.o.lines * 0.7))
  local win

  if layout == 'float' then
    width = math.min(width, math.max(1, vim.o.columns - 4))
    height = math.min(height, math.max(1, vim.o.lines - 4))
    win = vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = math.max(0, math.floor((vim.o.lines - height) / 2)),
      col = math.max(0, math.floor((vim.o.columns - width) / 2)),
      border = 'rounded',
    })
  else
    win = vim.api.nvim_open_win(buf, true, {
      split = 'below',
      height = math.min(12, math.max(1, vim.o.lines - 4)),
    })
  end

  vim.bo[buf].bufhidden = 'wipe'
  vim.keymap.set('n', 'q', function() close_terminal(buf, win) end, { buffer = buf, desc = 'Close terminal' })

  local job_id = vim.fn.termopen(vim.o.shell, { cwd = cwd })
  if job_id <= 0 then
    vim.notify('Failed to start terminal shell', vim.log.levels.ERROR)
    close_terminal(buf, win)
    return
  end

  vim.cmd.startinsert()
end

vim.keymap.set('n', '<leader>tf', function() open_terminal 'float' end, { desc = 'Open terminal float' })
vim.keymap.set('n', '<leader>tt', function() open_terminal 'split' end, { desc = 'Open terminal split' })
