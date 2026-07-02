-- Custom Code Runner with Floating Window
-- Keybinding: <leader>r  to run current file
-- Press <Esc> to close the floating output window

---@module 'lazy'
---@type LazySpec
return {
  -- This is a "virtual" plugin entry that lazy.nvim will load.
  -- We use dir pointing to a non-existent path so lazy treats it as config-only.
  'custom-coderunner',
  virtual = true,
  config = function()
    -- Register filetypes for languages Neovim doesn't know out of the box
    vim.filetype.add {
      extension = {
        c3 = 'c3',
        c3i = 'c3',
        odin = 'odin',
        nim = 'nim',
        nims = 'nim',
        nimble = 'nim',
      },
    }

    -----------------------------------------------------------
    -- 1. Language → command mapping
    -----------------------------------------------------------
    local runners = {
      python = function(f) return { 'python3', f } end,
      lua = function(f) return { 'lua', f } end,
      javascript = function(f) return { 'node', f } end,
      typescript = function(f) return { 'tsx', f } end,
      c = function(f)
        local out = f:gsub('%.c$', '')
        return { 'sh', '-c', 'gcc -o ' .. vim.fn.shellescape(out) .. ' ' .. vim.fn.shellescape(f) .. ' && ' .. vim.fn.shellescape(out) }
      end,
      cpp = function(f)
        local out = f:gsub('%.cpp$', '')
        return { 'sh', '-c', 'g++ -std=c++11 -o ' .. vim.fn.shellescape(out) .. ' ' .. vim.fn.shellescape(f) .. ' && ' .. vim.fn.shellescape(out) }
      end,
      go = function(f) return { 'go', 'run', f } end,
      rust = function(f) return { 'sh', '-c', 'rustc ' .. vim.fn.shellescape(f) .. ' -o /tmp/_rust_out && /tmp/_rust_out' } end,
      sh = function(f) return { 'bash', f } end,
      bash = function(f) return { 'bash', f } end,
      zsh = function(f) return { 'zsh', f } end,
      ruby = function(f) return { 'ruby', f } end,
      java = function(f)
        local dir = vim.fn.fnamemodify(f, ':h')
        local name = vim.fn.fnamemodify(f, ':t:r')
        return { 'sh', '-c', 'cd ' .. vim.fn.shellescape(dir) .. ' && javac ' .. vim.fn.shellescape(f) .. ' && java ' .. name }
      end,
      perl = function(f) return { 'perl', f } end,
      r = function(f) return { 'Rscript', f } end,
      swift = function(f) return { 'swift', f } end,
      c3 = function(f) return { 'c3c', 'compile-run', f } end,
      zig = function(f) return { 'zig', 'run', f } end,
      nim = function(f) return { 'nim', 'r', '--hints:off', '--verbosity:0', f } end,
      odin = function(f)
        local dir = vim.fn.fnamemodify(f, ':h')
        return { 'odin', 'run', dir }
      end,
      dart = function(f) return { 'dart', 'run', f } end,
      cs = function(f) return { 'dotnet', 'script', f } end,
      scala = function(f) return { 'scala', f } end,
      kotlin = function(f)
        if f:match('%.kts$') then
          return { 'kotlinc', '-script', f }
        end
        local jar = '/tmp/_kotlin_out.jar'
        return { 'sh', '-c', 'kotlinc ' .. vim.fn.shellescape(f) .. ' -include-runtime -d ' .. jar .. ' && java -jar ' .. jar }
      end,
    }

    -----------------------------------------------------------
    -- 2. Floating window creator
    -----------------------------------------------------------
    local function create_float(title)
      local buf = vim.api.nvim_create_buf(false, true)
      vim.bo[buf].bufhidden = 'wipe'

      -- Calculate window size (80% of editor)
      local width = math.floor(vim.o.columns * 0.8)
      local height = math.floor(vim.o.lines * 0.8)
      local row = math.floor((vim.o.lines - height) / 2)
      local col = math.floor((vim.o.columns - width) / 2)

      local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded',
        title = ' ' .. title .. ' ',
        title_pos = 'center',
      })

      -- Style the window
      vim.api.nvim_set_option_value('winblend', 0, { win = win })
      vim.api.nvim_set_option_value('cursorline', true, { win = win })
      vim.api.nvim_set_option_value('wrap', true, { win = win })

      -- Set highlight for the floating window
      vim.api.nvim_set_option_value('winhighlight', 'Normal:NormalFloat,CursorLine:Visual', { win = win })

      -- <Esc> to close the floating window
      vim.keymap.set('n', '<Esc>', function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end, { buffer = buf, nowait = true, desc = 'Close code runner window' })

      -- q to also close the floating window
      vim.keymap.set('n', 'q', function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end, { buffer = buf, nowait = true, desc = 'Close code runner window' })

      return buf, win
    end

    -----------------------------------------------------------
    -- 3. SQL execution via vim-dadbod
    -----------------------------------------------------------
    local function run_sql()
      vim.cmd('silent! write')
      local filepath = vim.fn.expand('%:p')
      if filepath == '' then
        vim.notify(' No SQL file to run', vim.log.levels.WARN)
        return
      end

      -- Check if vim-dadbod is available
      local has_dadbod = vim.fn.exists(':DB') == 2
      if not has_dadbod then
        vim.notify(' vim-dadbod is not loaded. Open :DBUI first or run :DB <url> < file', vim.log.levels.WARN)
        return
      end

      -- Try to get the active DBUI connection URL
      local db_url = nil
      -- Check if dadbod-ui has an active connection
      if vim.fn.exists('*db_ui#resolve') == 1 then
        db_url = vim.fn['db_ui#resolve'](vim.api.nvim_get_current_buf())
      end
      -- Fallback: check b:db variable (set by dadbod-ui when a buffer is associated)
      if (not db_url or db_url == '') and vim.b.db and vim.b.db ~= '' then
        db_url = vim.b.db
      end
      -- Fallback: check the global DBUI_URL environment variable
      if (not db_url or db_url == '') then
        db_url = vim.env.DBUI_URL
      end

      if not db_url or db_url == '' then
        vim.notify(
          ' No active database connection.\n'
            .. '  → Use <leader>db to open DBUI and select a database, or\n'
            .. '  → Run :DB <url> to set a connection, or\n'
            .. '  → Set $DBUI_URL environment variable',
          vim.log.levels.WARN
        )
        return
      end

      -- Read the SQL file content
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local sql = table.concat(lines, '\n')

      if vim.fn.trim(sql) == '' then
        vim.notify(' SQL file is empty', vim.log.levels.WARN)
        return
      end

      -- Execute via :DB command
      vim.cmd('DB ' .. db_url .. ' ' .. sql)
    end

    -----------------------------------------------------------
    -- 4. Main run function
    -----------------------------------------------------------
    local function run_code()
      -- Save the file first
      vim.cmd('silent! write')

      local filetype = vim.bo.filetype
      local filepath = vim.fn.expand('%:p')

      if filepath == '' then
        vim.notify(' No file to run', vim.log.levels.WARN)
        return
      end

      -- Special handling for SQL files: use vim-dadbod
      if filetype == 'sql' or filetype == 'mysql' or filetype == 'plsql' then
        run_sql()
        return
      end

      local runner = runners[filetype]
      if not runner then
        vim.notify(' No runner configured for filetype: ' .. filetype, vim.log.levels.WARN)
        return
      end

      local cmd = runner(filepath)

      -- Create floating window with a "running" indicator
      local display_name = vim.fn.fnamemodify(filepath, ':t')
      local buf, win = create_float('⏳ Running: ' .. display_name)

      -- Show a spinner / loading message
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        '  Running ' .. display_name .. ' ...',
        '',
        '  ⏳ Please wait...',
      })

      -- Collect output
      local output_lines = {}
      local start_time = vim.uv.hrtime()

      vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        stderr_buffered = true,

        on_stdout = function(_, data)
          if data then
            for _, line in ipairs(data) do
              if line ~= '' then
                table.insert(output_lines, line)
              end
            end
          end
        end,

        on_stderr = function(_, data)
          if data then
            for _, line in ipairs(data) do
              if line ~= '' then
                table.insert(output_lines, '❌ ' .. line)
              end
            end
          end
        end,

        on_exit = function(_, exit_code)
          vim.schedule(function()
            if not vim.api.nvim_win_is_valid(win) then return end

            local elapsed = (vim.uv.hrtime() - start_time) / 1e6 -- ms
            local elapsed_str
            if elapsed < 1000 then
              elapsed_str = string.format('%.0fms', elapsed)
            else
              elapsed_str = string.format('%.2fs', elapsed / 1000)
            end

            -- Build result header
            local status_icon = exit_code == 0 and '✅' or '❌'
            local status_text = exit_code == 0 and 'Success' or ('Failed (exit code: ' .. exit_code .. ')')
            local header = {
              '  ' .. status_icon .. '  ' .. status_text .. '  ⏱  ' .. elapsed_str,
              '  ─────────────────────────────────────────────',
              '',
            }

            -- Update the floating window title
            local new_title = status_icon .. ' ' .. display_name
            vim.api.nvim_win_set_config(win, { title = ' ' .. new_title .. ' ', title_pos = 'center' })

            -- Combine header + output
            local result = {}
            for _, line in ipairs(header) do
              table.insert(result, line)
            end
            if #output_lines == 0 then
              table.insert(result, '  (no output)')
            else
              for _, line in ipairs(output_lines) do
                table.insert(result, '  ' .. line)
              end
            end

            vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)

            -- Move cursor to top
            vim.api.nvim_win_set_cursor(win, { 1, 0 })
          end)
        end,
      })
    end

    -----------------------------------------------------------
    -- 5. Interactive terminal run (supports stdin input)
    -----------------------------------------------------------
    local function run_code_interactive()
      -- Save the file first
      vim.cmd('silent! write')

      local filetype = vim.bo.filetype
      local filepath = vim.fn.expand('%:p')

      if filepath == '' then
        vim.notify(' No file to run', vim.log.levels.WARN)
        return
      end

      local runner = runners[filetype]
      if not runner then
        vim.notify(' No runner configured for filetype: ' .. filetype, vim.log.levels.WARN)
        return
      end

      local cmd = runner(filepath)

      -- Build a shell command string from the cmd table
      local shell_cmd
      if cmd[1] == 'sh' and cmd[2] == '-c' then
        shell_cmd = cmd[3]
      else
        local parts = {}
        for _, part in ipairs(cmd) do
          table.insert(parts, vim.fn.shellescape(part))
        end
        shell_cmd = table.concat(parts, ' ')
      end

      -- Create floating window for terminal
      local display_name = vim.fn.fnamemodify(filepath, ':t')
      local buf = vim.api.nvim_create_buf(false, true)
      vim.bo[buf].bufhidden = 'wipe'

      local width = math.floor(vim.o.columns * 0.8)
      local height = math.floor(vim.o.lines * 0.8)
      local row = math.floor((vim.o.lines - height) / 2)
      local col = math.floor((vim.o.columns - width) / 2)

      local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded',
        title = ' 🖥  Interactive: ' .. display_name .. ' ',
        title_pos = 'center',
      })

      vim.api.nvim_set_option_value('winblend', 0, { win = win })
      vim.api.nvim_set_option_value('winhighlight', 'Normal:NormalFloat', { win = win })

      -- Open a real terminal in this floating buffer
      vim.fn.termopen(shell_cmd, {
        on_exit = function(_, exit_code)
          vim.schedule(function()
            if not vim.api.nvim_win_is_valid(win) then return end
            local icon = exit_code == 0 and '✅' or '❌'
            vim.api.nvim_win_set_config(win, {
              title = ' ' .. icon .. ' ' .. display_name .. ' (press q to close) ',
              title_pos = 'center',
            })
          end)
        end,
      })

      -- Start in terminal insert mode so user can type immediately
      vim.cmd('startinsert')

      -- Map q and <Esc> in normal mode to close (user can press <Esc> first to exit terminal mode, then q to close)
      vim.keymap.set('n', 'q', function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end, { buffer = buf, nowait = true, desc = 'Close interactive runner window' })

      vim.keymap.set('n', '<Esc>', function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end, { buffer = buf, nowait = true, desc = 'Close interactive runner window' })
    end

    -----------------------------------------------------------
    -- 6. Keymaps
    -----------------------------------------------------------
    vim.keymap.set('n', '<leader>r', run_code, { desc = '[R]un Code' })
    vim.keymap.set('n', '<leader>R', run_code_interactive, { desc = '[R]un Code (Interactive)' })

    -----------------------------------------------------------
    -- 7. Register with which-key (if available)
    -----------------------------------------------------------
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.add {
        { '<leader>r', desc = '[R]un Code' },
        { '<leader>R', desc = '[R]un Code (Interactive)' },
      }
    end
  end,
}
