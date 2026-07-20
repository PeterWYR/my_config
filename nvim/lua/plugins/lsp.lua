local languages = require("config.languages")
local servers = languages.lsp_servers()
local server_names = vim.tbl_keys(servers)
table.sort(server_names)

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      local parsers = languages.treesitter_parsers()
      local supported = {}
      local pending = {}
      local aggregate_install_task
      for _, parser in ipairs(parsers) do
        supported[parser] = true
      end

      local function notify(action, language, err)
        vim.notify(
          ("Treesitter %s failed for %s: %s"):format(action, language, tostring(err)),
          vim.log.levels.ERROR,
          { title = "Treesitter" }
        )
      end

      local function buffer_language(bufnr)
        local filetype = vim.bo[bufnr].filetype
        return vim.treesitter.language.get_lang(filetype) or filetype
      end

      local function start(bufnr, language)
        local ok, err = pcall(vim.treesitter.start, bufnr, language)
        if not ok then
          notify("start", language, err)
        end
      end

      local function load_parser(language, report_error)
        local call_ok, loaded, load_err = pcall(vim.treesitter.language.add, language)
        if call_ok and loaded then
          return true
        end
        if report_error then
          notify("load", language, call_ok and (load_err or "parser unavailable after install") or loaded)
        end
        return false
      end

      local function start_after_install(bufnr, language, task)
        task:await(function(err, success)
          if pending[language] == task then
            pending[language] = nil
          end

          if (err or not success) and task ~= aggregate_install_task then
            notify("install", language, err or "installer returned unsuccessful result")
          end

          if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
            return
          end
          if buffer_language(bufnr) ~= language then
            return
          end

          if not load_parser(language, true) then
            return
          end

          start(bufnr, language)
        end)
      end

      local function install_and_start(bufnr, language)
        local task = pending[language]
        if not task then
          local ok, result = pcall(treesitter.install, { language })
          if not ok then
            notify("install", language, result)
            return
          end
          if type(result) ~= "table" or type(result.await) ~= "function" then
            notify("install", language, "installer returned no async task")
            return
          end
          task = result
          pending[language] = task
        end

        start_after_install(bufnr, language, task)
      end

      local install_parsers = languages.treesitter_install_parsers()
      local install_ok, install_task = pcall(treesitter.install, install_parsers)
      if not install_ok then
        notify("bootstrap install", "configured parsers", install_task)
      elseif type(install_task) ~= "table" or type(install_task.await) ~= "function" then
        notify("bootstrap install", "configured parsers", "installer returned no async task")
      else
        aggregate_install_task = install_task
        for _, parser in ipairs(install_parsers) do
          pending[parser] = install_task
        end
        install_task:await(function(err, success)
          for _, parser in ipairs(install_parsers) do
            if pending[parser] == install_task then
              pending[parser] = nil
            end
          end
          if err or not success then
            notify("bootstrap install", "configured parsers", err or "installer returned unsuccessful result")
          end
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
        callback = function(args)
          local language = buffer_language(args.buf)
          if not supported[language] then
            return
          end

          if load_parser(language, false) then
            start(args.buf, language)
          else
            install_and_start(args.buf, language)
          end
        end,
      })
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = { "lua" },
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    opts = {
      ensure_installed = server_names,
      automatic_enable = false,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      local capabilities = require("blink.cmp").get_lsp_capabilities()
      for name, config in pairs(servers) do
        config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
        vim.lsp.config(name, config)
      end

      vim.lsp.enable(server_names)
    end,
  },
}
