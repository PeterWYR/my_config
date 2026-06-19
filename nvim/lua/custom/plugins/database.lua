-- Database support for Neovim (MySQL, PostgreSQL, SQLite3, DuckDB)
-- Uses vim-dadbod + vim-dadbod-ui + vim-dadbod-completion
--
-- Prerequisites (CLI tools must be in $PATH):
--   brew install mysql-client   (provides `mysql`)
--   brew install libpq          (provides `psql`)
--   brew install sqlite3        (provides `sqlite3`, usually pre-installed on macOS)
--   brew install duckdb         (provides `duckdb`)
--
-- Usage:
--   <leader>db  — Toggle DBUI sidebar
--   <leader>da  — Add a new database connection
--   <leader>df  — Find a saved query buffer
--   <leader>dl  — Last executed query result
--   <leader>r   — (in .sql files) Execute SQL via dadbod against the active connection
--
-- Connection URLs examples (set in DBUI or via :DB command):
--   postgresql://user:pass@localhost:5432/mydb
--   mysql://root@localhost/mydb
--   sqlite:path/to/db.sqlite3
--   duckdb:path/to/db.duckdb   (or duckdb: for in-memory)

---@module 'lazy'
---@type LazySpec
return {
  {
    'tpope/vim-dadbod',
    cmd = { 'DB' },
    lazy = true,
  },

  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    keys = {
      { '<leader>db', '<cmd>DBUIToggle<CR>', desc = '[D]ata[B]ase UI toggle' },
      { '<leader>da', '<cmd>DBUIAddConnection<CR>', desc = '[D]atabase [A]dd connection' },
      { '<leader>df', '<cmd>DBUIFindBuffer<CR>', desc = '[D]atabase [F]ind buffer' },
      { '<leader>dl', '<cmd>DBUILastQueryInfo<CR>', desc = '[D]atabase [L]ast query info' },
    },
    init = function()
      -- DBUI configuration
      vim.g.db_ui_use_nerd_fonts = vim.g.have_nerd_font and 1 or 0
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_win_position = 'left'
      vim.g.db_ui_winwidth = 40

      -- Use a dedicated directory for saved queries
      vim.g.db_ui_save_location = vim.fn.stdpath 'data' .. '/db_ui'

      -- Execute SQL with <leader>r in sql filetype buffers managed by dadbod-ui
      -- This integrates with the user's existing <leader>r "run" muscle memory
      vim.g.db_ui_execute_on_save = false -- don't auto-execute on :w

      -----------------------------------------------------------
      -- Autocompletion: wire dadbod-completion into blink.cmp
      -----------------------------------------------------------
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'sql', 'mysql', 'plsql' },
        callback = function()
          -- dadbod-completion provides an omnifunc; set it for the buffer
          vim.bo.omnifunc = 'vim_dadbod_completion#omni'
        end,
      })
    end,
    config = function()
      -----------------------------------------------------------
      -- Register which-key group for database keymaps
      -----------------------------------------------------------
      local ok, wk = pcall(require, 'which-key')
      if ok then
        wk.add {
          { '<leader>d', group = '[D]atabase' },
        }
      end
    end,
  },
}
