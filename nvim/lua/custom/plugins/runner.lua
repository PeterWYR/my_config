local runner_buf

local function quote(value) return vim.fn.shellescape(value) end

local function compile_and_run(compiler, file, suffix)
  local output = vim.fn.tempname() .. (suffix or '')
  return ('%s %s -o %s && %s; status=$?; rm -f %s; exit $status'):format(compiler, quote(file), quote(output), quote(output), quote(output))
end

local runners = {
  c = function(file) return compile_and_run('cc', file) end,
  cpp = function(file) return compile_and_run('c++', file) end,
  c3 = function(file) return 'c3c compile-run ' .. quote(file) end,
  python = function(file) return 'python3 ' .. quote(file) end,
  java = function(file) return 'java ' .. quote(file) end,
  scala = function(file)
    local path = quote(file)
    return ('if command -v scala-cli >/dev/null 2>&1; then scala-cli run %s; else scala %s; fi'):format(path, path)
  end,
  go = function(file) return 'go run ' .. quote(file) end,
  rust = function(file) return compile_and_run('rustc', file) end,
  javascript = function(file) return 'node ' .. quote(file) end,
  javascriptreact = function(file) return 'npx --yes tsx ' .. quote(file) end,
  typescript = function(file) return 'npx --yes tsx ' .. quote(file) end,
  typescriptreact = function(file) return 'npx --yes tsx ' .. quote(file) end,
  kotlin = function(file)
    local output = vim.fn.tempname() .. '.jar'
    return ('kotlinc %s -include-runtime -d %s && java -jar %s; status=$?; rm -f %s; exit $status'):format(
      quote(file),
      quote(output),
      quote(output),
      quote(output)
    )
  end,
  zig = function(file) return 'zig run ' .. quote(file) end,
}

local function run_current_file()
  local source_buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(source_buf)
  local runner = runners[vim.bo[source_buf].filetype]

  if file == '' then
    vim.notify('Save the file before running it', vim.log.levels.WARN)
    return
  end
  if not runner then
    vim.notify('No runner for filetype: ' .. vim.bo[source_buf].filetype, vim.log.levels.WARN)
    return
  end

  local saved, err = pcall(vim.cmd, 'silent write')
  if not saved then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  if runner_buf and vim.api.nvim_buf_is_valid(runner_buf) then vim.api.nvim_buf_delete(runner_buf, { force = true }) end

  local height = math.min(12, math.max(1, vim.o.lines - 4))
  vim.cmd(('botright %dnew'):format(height))
  runner_buf = vim.api.nvim_get_current_buf()
  vim.bo[runner_buf].bufhidden = 'wipe'
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = 'no'

  vim.keymap.set('n', 'q', function()
    if vim.api.nvim_buf_is_valid(runner_buf) then vim.api.nvim_buf_delete(runner_buf, { force = true }) end
  end, { buffer = runner_buf, desc = 'Close code runner' })

  local job = vim.fn.termopen(runner(file), { cwd = vim.fs.dirname(file) })
  if job <= 0 then
    vim.notify('Failed to start code runner', vim.log.levels.ERROR)
    vim.api.nvim_buf_delete(runner_buf, { force = true })
    return
  end

  vim.cmd.startinsert()
end

vim.keymap.set('n', '<leader>r', run_current_file, { desc = '[R]un current file' })
