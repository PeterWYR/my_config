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

local function open_terminal()
  local cwd = terminal_cwd()
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    split = 'below',
    height = math.min(12, math.max(1, vim.o.lines - 4)),
  })

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

vim.keymap.set('n', '<leader>tt', open_terminal, { desc = 'Open terminal split' })
