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
      },
    }

    -----------------------------------------------------------
    -- 1. Language → command mapping
    -----------------------------------------------------------
    local runners = {
      python = function(f) return { 'python3', f } end,
      lua = function(f) return { 'lua', f } end,
      javascript = function(f) return { 'node', f } end,
      typescript = function(f) return { 'node', f } end,
      c = function(f)
        local out = f:gsub('%.c$', '')
        return { 'sh', '-c', 'gcc -o ' .. vim.fn.shellescape(out) .. ' ' .. vim.fn.shellescape(f) .. ' && ' .. vim.fn.shellescape(out) }
      end,
      cpp = function(f)
        local out = f:gsub('%.cpp$', '')
        return { 'sh', '-c', 'g++ -std=c++23 -o ' .. vim.fn.shellescape(out) .. ' ' .. vim.fn.shellescape(f) .. ' && ' .. vim.fn.shellescape(out) }
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
      vim.api.nvim_set_option_value('winblend', 5, { win = win })
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
    -- 3. Main run function
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
    -- 4. Keymap: <leader>r to run code
    -----------------------------------------------------------
    vim.keymap.set('n', '<leader>r', run_code, { desc = '[R]un Code' })

    -----------------------------------------------------------
    -- 5. Register with which-key (if available)
    -----------------------------------------------------------
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.add {
        { '<leader>r', desc = '[R]un Code' },
      }
    end
  end,
}
